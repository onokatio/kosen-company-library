#!/bin/bash

USERNAME=hoge
PASSWORD=fuga

curl -SsL -c cookie.txt -X POST --data "user_name=USERNAME&user_pass=PASSWORD&top_login_submit=login&my_nonce_name=b19523b82d" "https://library.kosen-gosetsu.com/" \
	| pup '.company-table tbody tr td a attr{href}' > companylist.txt

while read line; do
	curl -SsL -b cookie.txt $line \
		| pup '.company-detail__section:nth-of-type(4) > .company-detail__data:nth-of-type(4) > .company-detail__data__value text{}' \
		| tr -d '\n,' | tr -c '[:digit:]' '\n' | sort | uniq | grep -E '^[0-9]{6}$' | sort | head -n1
done < companylist.txt | awk '{sum+=$1} END {print sum/NR}'
