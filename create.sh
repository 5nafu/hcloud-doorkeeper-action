#! /bin/sh

echo "Env:"
env
echo "----------------------------"
if [[ -n "$INPUT_IP" ]]; then
    IP_RANGE="$INPUT_IP"
else
    echo "Getting Public IP..."
    IP_RANGE="$(wget -O- -q http://ifconfig.me/ip )/32"
fi

case $0 in
    create.sh)
        ACTION=add-rule
        ;;
    delete.sh)
        ACTION=delete-rule
        if [[ "$INPUT_AUTOCLEAN" != "true" ]]; then
            echo "Cleanup not required due to options"
            exit 0
        fi
        ;;
esac

echo /usr/local/bin/hcloud firewall $ACTION \
    $INPUT_FIREWALL_NAME \
    --direction in \
    --port ${{ INPUT_PORT }} \
    --protocol $INPUT_PROTOCOL \
    --source-ips $IP_RANGE \
    --description Doorkeeper Rule - Repository $GITHUB_REPOSITORY - Workflow: $GITHUB_WORKFLOW/$GITHUB_RUN_NUMBER/$GITHUB_RUN_ATTEMPT