PACKER_VERSION="1.7.8"

if [ ! -f ./packer ]; then
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip;
    unzip packer_${PACKER_VERSION}_linux_amd64.zip;
    rm packer_${PACKER_VERSION}_linux_amd64.zip;
fi

export PACKER_LOG=1
export PACKER_LOG_PATH="/mnt/storage/qiling/log"
./packer validate spec-2017/spec-2017.json
./packer build spec-2017/spec-2017.json
