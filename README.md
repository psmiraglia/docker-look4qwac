# look4qwac

Docker image to check if TLS is implemented with a QWAC certificate.

## How to use

1.  Build the image

        $ make

    or

        $ docker build --tag psmiraglia/look4qwac .

2.  Add the URL(s) you want to check in a file (one per line)

        $ echo "https://my.qwac.example.com" >> urls.txt
        $ echo "https://my.other.qwac.example.com" >> urls.txt

3.  Run the container as follows

        $ docker run -ti --rm \
            -v "/local/path/to/urls.txt:/tmp/urls.txt:ro" \
            psmiraglia/look4qwac /tmp/urls.txt

    If QWAC, you should see something like that

        -----BEGIN https://my.qwac.example.com -----
        69:d=5  hl=2 l=   3 prim: OBJECT            :organizationIdentifier
        74:d=5  hl=2 l=  14 prim: UTF8STRING        :XXXXX-00000000
        1120:d=5  hl=2 l=   8 prim: OBJECT            :qcStatements
        0:d=0  hl=2 l= 104 cons: SEQUENCE          
        2:d=1  hl=2 l=  10 cons: SEQUENCE          
        4:d=2  hl=2 l=   8 prim: OBJECT            :1.3.6.1.5.5.7.11.2 (id-qcs-pkixQCSyntax-v2)
        14:d=1  hl=2 l=   8 cons: SEQUENCE          
        16:d=2  hl=2 l=   6 prim: OBJECT            :0.4.0.1862.1.1 (qcs-QcCompliance)
        24:d=1  hl=2 l=  19 cons: SEQUENCE          
        26:d=2  hl=2 l=   6 prim: OBJECT            :0.4.0.1862.1.6 (qcs-QcType, Qualified Certificate Statement (QCS) claiming that the certificate is a European Union qualified certificate of a particular type)
        34:d=2  hl=2 l=   9 cons: SEQUENCE          
        36:d=3  hl=2 l=   7 prim: OBJECT            :0.4.0.1862.1.6.3 (qct-web, Certificate for website authentication as defined in European Union Regulation No 910 2014)
        45:d=1  hl=2 l=  59 cons: SEQUENCE          
        47:d=2  hl=2 l=   6 prim: OBJECT            :0.4.0.1862.1.5 (qcs-QcPDS, Qualified Certificate Statement (QCS) regarding location of Public-key infrastructure Disclosure Statements (PDSs))
        55:d=2  hl=2 l=  49 cons: SEQUENCE          
        57:d=3  hl=2 l=  47 cons: SEQUENCE          
        59:d=4  hl=2 l=  41 prim: IA5STRING         :https://www.quovadisglobal.com/repository
        102:d=4  hl=2 l=   2 prim: PRINTABLESTRING   :en
        -----END https://my.qwac.example.com -----


        -----BEGIN https://my.other.qwac.example.com -----
        Error: offset out of range
        -----END https://my.other.qwac.example.com -----
