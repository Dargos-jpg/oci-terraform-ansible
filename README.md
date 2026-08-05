# OCI Terraform + Ansible Lab

Proiect practic de Infrastructure as Code, construit pentru a demonstra
competențe reale în Terraform, Ansible, networking/security și CI/CD —
folosind infrastructură permanent gratuită (OCI Always Free).

## Arhitectură

```
                    Internet
                        |
                  [Internet Gateway]
                        |
                  [Security List]  <- SSH doar de la IP-ul meu, HTTP/HTTPS public
                        |
                    [Subnet public 10.0.1.0/24]
                    /                        \
        [app-server VM]              [monitoring-server VM]
        - Docker                     - Netdata / Prometheus
        - aplicatie deployata        - Node Exporter
        - fail2ban, UFW              - fail2ban, UFW
```

## Structură repo

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

1. `cp terraform.tfvars.example terraform.tfvars` și completează valorile
   tale (OCID-uri, fingerprint, cale cheie, IP-ul tău public).
2. `terraform init`
3. `terraform plan` — verifici ce urmează să se creeze
4. `terraform apply` — provizionează infrastructura
5. `ansible-playbook -i ansible/inventory.ini ansible/site.yml` — configurează VM-urile

## Status

- [x] Structură repo + module Terraform (network, compute)
- [ ] Cont OCI creat + chei API generate
- [ ] `terraform apply` rulat cu succes
- [ ] Rol Ansible hardening
- [ ] Rol Ansible docker + app-deploy
- [ ] Monitoring server (Netdata/Prometheus)
- [ ] GitHub Actions - plan automat pe PR
- [ ] GitHub Actions - apply automat pe merge + ansible

Detalii tehnice și decizii luate pe parcurs, în [NOTES.md](./NOTES.md).
