#!/usr/bin/env bash
source "${0%/*}/00_incl.sh"

# gcloud components install kubectl
CLUSTER_NAME=${cluster_name}

is_exists=$(gcloud container clusters get-credentials ${CLUSTER_NAME} 2>&1 | grep "No cluster named" |wc -l)
if [ ${is_exists} -eq 0 ]; then
    echo_green "Configure the Cluster '${CLUSTER_NAME}'"
    proj_number=$(gcloud projects describe ${project_id} --format="value(projectNumber)")
    sed -e "s/proj_number/$proj_number/g" -e "s/{NODE_ENV}/${NODE_ENV}/g" ../k8s/configs/arcadia-prod.properties > ../k8s/configs/arcadia-prod.properties.updated
    sed -e "s/{NEW_RELIC_LICENSE_KEY}/$NEW_RELIC_LICENSE_KEY/g" ../k8s/configs/secrets-arcadia-prod.properties > ../k8s/configs/secrets-arcadia-prod.properties.updated
    sed -e "s/{socketio_domain}/${socketio}/g" -e "s/{game_domain}/${game}/g" -e "s/{voucher_domain}/${voucher}/g" -e "s/{bo_domain}/${bo}/g" ../k8s/ingress/ingress.yaml > ../k8s/ingress/ingress-updated.yaml
    sed -e "s/{socketio_domain}/${socketio}/g" -e "s/{game_domain}/${game}/g" -e "s/{voucher_domain}/${voucher}/g" -e "s/{bo_domain}/${bo}/g" ../k8s/ingress/certs.yaml > ../k8s/ingress/certs-updated.yaml

    #rabbit namespace
    gcloud beta container clusters update ${CLUSTER_NAME} --enable-stackdriver-kubernetes
    gcloud container clusters get-credentials ${CLUSTER_NAME}
    kubectl create namespace production && kubectl create namespace rabbitmq

    sleep 10

    sed -e "s/{user}/$RABBITMQ_USERNAME/g" -e "s/{password}/$RABBITMQ_PASSWORD/g" ../../../arcadia.rabbitmq.cluster/rabbitmq_configmap.yaml > ../../../arcadia.rabbitmq.cluster/rabbitmq_configmap_c.yaml
    kubectl apply -f ../../../arcadia.rabbitmq.cluster/rabbitmq_configmap_c.yaml --namespace=rabbitmq
    rm ../../../arcadia.rabbitmq.cluster/rabbitmq_configmap_c.yaml
    kubectl apply -f ../../../arcadia.rabbitmq.cluster/rabbitmq_rbac.yaml --namespace=rabbitmq
    kubectl apply -f ../../../arcadia.rabbitmq.cluster/rabbitmq_service.yaml --namespace=rabbitmq
    kubectl apply -f ../../../arcadia.rabbitmq.cluster/rabbitmq_service_ext.yaml --namespace=rabbitmq
    kubectl apply -f ../../../arcadia.rabbitmq.cluster/rabbitmq_statefulset.yaml --namespace=rabbitmq
    #production namespace
    kubectl apply -f ../k8s/ingress/healthchecks_socketio.yaml --namespace=production
    kubectl apply -f ../k8s/ingress/healthchecks_be.yaml --namespace=production
    kubectl apply -f ../k8s/ingress/healthchecks_fe.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.backoffice.api/deployment/k8s/production/backoffice-api/service.yaml --namespace=production
    kubectl apply -f ../../../frontend/apps/arcadia.backoffice.fe/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.client.api/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../frontend/apps/arcadia.coin-pusher.fe/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.client.socketio.node/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.game.core.api/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.game.core.api/deployment/k8s/production/service_ext.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.game.core.worker/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.monitoring.api/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.monitoring.api/deployment/k8s/production/service_ext.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.monitoring.worker/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../backend/apps/arcadia.operator.factory/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../../../frontend/apps/arcadia.voucher.portal/deployment/k8s/production/service.yaml --namespace=production
    kubectl apply -f ../k8s/ingress/ingress-updated.yaml --namespace=production

    find ../../../ -name 'hpa.yaml' -exec kubectl apply -f {} --namespace=production \;
    kubectl create configmap arcadia-prod --namespace=production --from-env-file=../k8s/configs/arcadia-prod.properties.updated
    kubectl create secret generic arcadia-prod --namespace=production --from-env-file=../k8s/configs/secrets-arcadia-prod.properties.updated
    kubectl create secret generic sm-key --from-file=key.json=${sm_credentials_path} --namespace=production
    kubectl apply -f ../k8s/ingress/certs-updated.yaml --namespace=production

    rm ../k8s/configs/arcadia-prod.properties.updated
    rm ../k8s/configs/secrets-arcadia-prod.properties.updated
    rm ../k8s/ingress/ingress-updated.yaml
    rm ../k8s/ingress/certs-updated.yaml

    #update env variables
    rabbitmqHost=$(kubectl get svc rabbitmq -n rabbitmq -o=jsonpath="{.status.loadBalancer.ingress[0].ip}") && \
    echo $rabbitmqHost | gcloud secrets versions add EXTERNAL_RABBITMQ_HOST --data-file=-
    echo $rabbitmqHost | gcloud secrets versions add RABBITMQ_HOST --data-file=-
    echo_green "Cluster '${CLUSTER_NAME}' has been configured"
else
    echo_red "Cluster '${CLUSTER_NAME}' not exists"
fi


