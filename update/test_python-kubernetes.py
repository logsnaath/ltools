import os
from kubernetes import client, config

def list_pods():
    try:
        # Use the KUBECONFIG environment variable to set the Kubernetes configuration file
        kubeconfig_path = os.getenv("KUBECONFIG")
        if kubeconfig_path:
            config.load_kube_config(config_file=kubeconfig_path)
        else:
            # If KUBECONFIG is not set, it will fall back to loading the default configuration
            config.load_kube_config()

        # Create a Kubernetes API client
        v1 = client.CoreV1Api()

        # List all pods in all namespaces
        pods = v1.list_pod_for_all_namespaces()

        # Print pod names and statuses
        for pod in pods.items:
            namespace = pod.metadata.namespace
            name = pod.metadata.name
            status = pod.status.phase
            print(f"Namespace: {namespace}, Name: {name}, Status: {status}")

    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    list_pods()

