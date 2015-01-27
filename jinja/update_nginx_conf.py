from jinja2 import Template

# load the template
with open('pasties.conf.j2') as f:
    nginx_template = Template(f.read())

# load hosts from file
with open('hosts') as f:
    hosts = f.read().split()

# print hosts
print("Load balanced hosts:")
for host in hosts:
    print(host)

# save new configuration inside nginx configuration directory
with open('/etc/nginx/conf.d/default.conf', 'w') as f:
    nginx_config = nginx_template.render(hosts=hosts)
    f.write(nginx_config)
