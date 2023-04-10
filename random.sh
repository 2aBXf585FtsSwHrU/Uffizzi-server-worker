while true
do
  predictableUrl=${UFFIZZI_PREDICTABLE_URL#*://} # 去掉 http:// 部分
  echo "URL https://$predictableUrl"
  response=$(curl -s -o /dev/null -w "%{http_code}" -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" --socks5 127.0.0.1:21080 "https://$predictableUrl")
  if [ $response -eq 200 ]
  then
    echo -e "\n"
  else
    echo "访问失败，响应码为 $response"
  fi
  sleep $((35 + RANDOM % 25))
done
