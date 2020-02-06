#!/bin/bash

while IFS= read -r url; do
    cert_data=$(mktemp)

    # obtain servername for SNI
    servername=$(echo ${url} | sed -e "s/https:\/\///g" -e "s/\/.*//g")
    
    # obtain TLS certificate
    echo QUIT \
        | openssl s_client -connect ${servername}:443 -servername ${servername} 2>/dev/null \
        | openssl x509 -outform DER -out ${cert_data}

    echo "-----BEGIN ${url} -----"

    # organizationIdentifier
    openssl asn1parse -in ${cert_data} -inform DER \
        | grep "organizationIdentifier" -A1

    # qcStatements
    openssl asn1parse -in ${cert_data} -inform DER \
        | grep "qcStatements"

    # parse qcStatements
    # credits: https://gist.github.com/lucamartellucci/f04e3b6199bad07eb64fd8a0c5ffe401
    openssl asn1parse -in ${cert_data} -inform DER \
        | grep "qcStatements" -A1 \
        | grep "HEX DUMP" | cut -d':' -f4 \
        | xxd -r -p | base64 \
        | openssl asn1parse \
        | sed -r \
            -e "s/(0.4.0.1862.1.1)$/\1 (qcs-QcCompliance)/g" \
            -e "s/(1.3.6.1.5.5.7.11.2)$/\1 (id-qcs-pkixQCSyntax-v2)/g" \
            -e "s/(0.4.0.1862.1.6.3)$/\1 (qct-web, Certificate for website authentication as defined in European Union Regulation No 910 2014)/g" \
            -e "s/(0.4.0.1862.1.6)$/\1 (qcs-QcType, Qualified Certificate Statement (QCS) claiming that the certificate is a European Union qualified certificate of a particular type)/g" \
            -e "s/(0.4.0.1862.1.5)$/\1 (qcs-QcPDS, Qualified Certificate Statement (QCS) regarding location of Public-key infrastructure Disclosure Statements (PDSs))/g"

    echo "-----END ${url} -----"
    echo -e "\n\n"

    rm -f ${cert_data}
done < ${1:-/dev/null}
