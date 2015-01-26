from jinja2 import Template

with open('pasties.conf.j2') as f:
    nginx_template = Template(f.read())

with open('hosts') as f:
    hosts = f.read().split()
print(hosts)
with open('/etc/nginx/conf.d/default.conf', 'w') as f:
    nginx_config = nginx_template.render(hosts=hosts)
    f.write(nginx_config)
