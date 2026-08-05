# OCI Terraform + Ansible Lab

Proiect de Infrastructure as Code cu Terraform, Ansible, networking/security si CI/CD,
pe infrastructura OCI Always Free (gratuit permanent, spre deosebire de free tier-ul
de 12 luni de la AWS/Azure).

## Arhitectura

```
                    Internet
                        |
                  [Internet Gateway]
                        |
                  [Security List]  <- SSH doar de la IP autorizat, HTTP/HTTPS public
                        |
                    [Subnet public 10.0.1.0/24]
                    /                        \
        [app-server VM]              [monitoring-server VM]
        - Docker                     - Netdata / Prometheus
        - aplicatie deployata        - Node Exporter
        - fail2ban, UFW              - fail2ban, UFW
```

## Structura repo

```
.
├── main.tf                  # leaga modulele intre ele
├── providers.tf              # provider OCI + local
├── variables.tf               # variabile de intrare (credentiale, config)
├── outputs.tf                 # IP-uri publice ale VM-urilor
├── terraform.tfvars.example   # sablon - copiaza in terraform.tfvars
├── modules/
│   ├── network/                # VCN, subnet, gateway, security list
│   └── compute/                 # instante VM.Standard.A1.Flex (ARM, Always Free)
├── ansible/
│   ├── inventory.ini            # generat automat de Terraform (nu se editeaza manual)
│   └── roles/
│       ├── hardening/            # SSH, fail2ban, UFW
│       ├── docker/               # instalare Docker
│       └── app-deploy/           # deploy aplicatie containerizata
└── .github/workflows/            # CI/CD - plan automat la PR, apply la merge
```

## Setup

1. `cp terraform.tfvars.example terraform.tfvars`, apoi se completeaza valorile
   (OCID-uri, fingerprint, cale cheie, IP public).
2. `terraform init`
3. `terraform plan` - arata ce urmeaza sa se creeze
4. `terraform apply` - provizioneaza infrastructura
5. `ansible-playbook -i ansible/inventory.ini ansible/site.yml` - configureaza VM-urile

## Status

- [x] Structura repo + module Terraform (network, compute)
- [ ] Cont OCI creat + chei API generate
- [ ] `terraform apply` rulat cu succes
- [ ] Rol Ansible hardening
- [ ] Rol Ansible docker + app-deploy
- [ ] Monitoring server (Netdata/Prometheus)
- [ ] GitHub Actions - plan automat pe PR
- [ ] GitHub Actions - apply automat pe merge + ansible

Detalii tehnice si decizii, in [NOTES.md](./NOTES.md).
