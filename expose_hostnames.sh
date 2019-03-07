# install jq if not exists
if ! [ -x "$(command -v jq)" ]; then
    pushd /tmp
    wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
    mv jq-linux64 jq
    chmod a+x jq
    export PATH=$PATH:/tmp
    popd
fi


IFS=$'\n' # split on newline

networks=(`docker network list -q`)

cp /dev/null newhosts  # truncate newhosts

newhosts=()
for network in "${networks[@]}"; do
    newhosts+=(`docker network inspect ${network} | jq '.[0].Containers[] | .IPv4Address + " " + .Name' | sed 's/\"//g' | sed 's/\/[0-9][0-9]//g'`)
done

hosts=(`cat /etc/hosts`)
skip="false"
for host in "${hosts[@]}"; do
    if [ $host == "# begin added by spencer" ]; then
        skip="true"
    fi
    if [ $skip == "false" ]; then
        echo $host >> newhosts
    fi
    if [ $host == "# end added by spencer" ]; then
        skip="false"
    fi
done

echo "Adding the following DNS lookups to your /etc/hosts file"

echo "# begin added by spencer" >> newhosts
for host in "${newhosts[@]}"; do
    echo $host
    echo $host >> newhosts
done
echo "# end added by spencer" >> newhosts

sudo cp newhosts /etc/hosts
