IFS=$'\n' # split on newline

networks=(`docker network list -q`)

cp /dev/null newhosts  # truncate newhosts

newhosts=()
for network in "${networks[@]}"; do
    newhosts+=(`docker network inspect ${network} | jq '.[0].Containers[] | .IPv4Address + " " + .Name' | sed 's/\"//g' | sed 's/\/20//g'`)
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

echo "# begin added by spencer" >> newhosts
for host in "${newhosts[@]}"; do
    echo $host >> newhosts
done
echo "# end added by spencer" >> newhosts

sudo cp newhosts /etc/hosts
