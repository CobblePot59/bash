#coding: utf-8

import json
import ovh
import os
from requests import get

v_ak=input('Enter your application_key value: ')
v_as=input('Enter your application_secret value: ')
v_ck=input('Enter your consumer_key value: ')

client = ovh.Client(
    endpoint='ovh-eu',       # Endpoint of API OVH Europe (List of available endpoints)
    application_key=v_ak,    # Application Key
    application_secret=v_as, # Application Secret
    consumer_key=v_ck,       # Consumer Key
)

public_ip=get('http://ident.me').text
domain_name=os.environ['DOMAIN_NAME']
short_name=os.environ['SHORT_NAME']

a_entry = client.post('/domain/zone/'+domain_name+'/record',
    fieldType='A', # Resource record Name (type: zone.NamedResolutionFieldTypeEnum)
    subDomain=short_name, # Resource record subdomain (type: string)
    target=public_ip, # Resource record target (type: string)
    ttl=None, # Resource record ttl (type: long)
)

# Pretty print
print (json.dumps(a_entry, indent=4))

spf_entry = client.post('/domain/zone/'+domain_name+'/record',
    fieldType='SPF', # Resource record Name (type: zone.NamedResolutionFieldTypeEnum)
    subDomain=short_name, # Resource record subdomain (type: string)
    target='v=spf1 ip4:'+public_ip+' ~all', # Resource record target (type: string)
    ttl=None, # Resource record ttl (type: long)
)

# Pretty print
print (json.dumps(spf_entry, indent=4))

result = client.post('/domain/zone/'+domain_name+'/refresh')

# Pretty print
print (json.dumps(result, indent=4))