FROM docker.io/library/ubuntu:24.04
ARG TARGETPLATFORM

ARG DEBIAN_FRONTEND="noninteractive"
RUN --mount=type=cache,target=/var/lib/apt,sharing=locked --mount=type=tmpfs,target=/var/log set -eux; \
  apt-get -qq update; \
  apt-get -qqy upgrade; \
  apt-get -qqy --no-install-recommends install \
  adduser bash bash-completion ca-certificates curl git gnupg2 locales openssh-client sudo unzip xz-utils; \
  mkdir -p /etc/skel/.bashrc.d; \
  printf "for f in \"\${HOME}\"/.bashrc.d/*; do . \"\${f}\"; done\n" | tee -a /etc/skel/.bashrc; \
  mkdir -p /etc/skel/.local/bin; \
  printf "export PATH=\"\${HOME}/.local/bin:\${PATH}\"\n" | tee /etc/skel/.bashrc.d/00-local-bin.sh; \
  locale-gen "en_GB.UTF-8"; \
  update-ca-certificates;
ENV LANG="en_GB.UTF-8"

# renovate: datasource=git-tags depName=https://github.com/docker/cli extractVersion=v(?<version>.+)$
ARG DOCKER_VERSION="28.3.3"
# renovate: datasource=git-tags depName=https://github.com/docker/buildx extractVersion=v(?<version>.+)$
ARG DOCKER_BUILDX_VERSION="0.26.1"
# renovate: datasource=git-tags depName=https://github.com/docker/compose extractVersion=v(?<version>.+)$
ARG DOCKER_COMPOSE_VERSION="2.39.2"
RUN --mount=type=cache,target=/var/lib/apt,sharing=locked --mount=type=tmpfs,target=/var/log set -eux; \
  # GPG_KEY="$(curl -fsSL https://download.docker.com/linux/ubuntu/gpg | base64 -w 0)"; \
  GPG_KEY="LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUlOQkZpdDJpb0JFQURoV3BaOC93dlo2aFVUaVhPd1FIWE1BbGFGSGNQSDloQXRyNEYxeTIrT1lkYnRNdXRoCmxxcXdwMDI4QXF5WStQUmZWTXRTWU1ianVRdXU1Ynl5S1IwMUJicVlodVMzanRxUW1salovYkp2WHFubWlWWGgKMzhVdUxhK3owNzdQeHl4UWh1NUJicW50VFBRTWZpeXFFaVUrQkticTJXbUFOVUtRZisxQW1aWS9JcnVPWGJucQpMNEMxK2dKOHZmbVhRdDk5bnBDYXhFamFOUlZZZk9TOFFjaXhOekhVWW5iNmVtamxBTnlFVmxaemVxbzdYS2w3ClVyd1Y1aW5hd1RTeldOdnRqRWpqNG5KTDhOc0x3c2NwTFBRVWhUUSs3QmJRWEF3QW1lSENVVFFJdnZXWHF3ME4KY21oaDRIZ2VRc2NRSFlnT0pqakRWZm9ZNU11Y3ZnbGJJZ0NxZnpBSFc5anhtUkw0cWJNWmorYjFYb2VQRXRodAprdTRiSVFOMVg1UDA3Zk5XemxnYVJMNVo0UE9YRERaVGxJUS9FbDU4ajlrcDRibldSQ0pXMGx5YStmOG9jb2RvCnZaWitEb2krZnk0RDVaR3JMNFhFY0lRUC9MdjV1RnlmK2tRdGwvOTRWRllWSk9sZUF2OFc5MktkZ0RraFRjVEQKRzdjMHRJa1ZFS05VcTQ4YjNhUTY0Tk9aUVc3ZlZqZm9Ld0VaZE9xUEU3MlBhNDVqclp6dlVGeFNwZGlOazJ0WgpYWXVrSGpseHhFZ0JkQy9KM2NNTU5SRTFGNE5DQTNBcGZWMVk3L2hUZU9ubUR1RFl3cjkvb2JBOHQwMTZZbGpqCnE1cmRreXdQZjRKRjhtWFVXNWVDTjF2QUZIeGVnOVpXZW1oQnRRbUd4WG53OU0rejZoV3djNmFobXdBUkFRQUIKdEN0RWIyTnJaWElnVW1Wc1pXRnpaU0FvUTBVZ1pHVmlLU0E4Wkc5amEyVnlRR1J2WTJ0bGNpNWpiMjAraVFJMwpCQk1CQ2dBaEJRSllyZWZBQWhzdkJRc0pDQWNEQlJVS0NRZ0xCUllDQXdFQUFoNEJBaGVBQUFvSkVJMkJnRHdPCnY4Mklzc2tQL2lRWm82OGZsRFFtTnZuOFg1WFRkNlJSYVVIMzNrWFlYcXVUNk5rSEpjaVM3RTJnVEptcXZNcWQKdEk0bU5ZSENTRVl4STVxcmNZVjVZcVg5UDYrS28rdm96bzRuc2VVUUxQSC9BVFE0cUwwWm9rKzFqa2FnM0xnawpqb255VWY5Ynd0V3hGcDA1SEMzR01IUGhoY1VTZXhDeFFMUXZuRldYRDJzV0xLaXZIcDJmVDhRYlJHZVorZDNtCjZmcWNkNUZ1N3B4c3FtMEVVREs1TkwrblBJZ1loTithdVRyaGd6aEsxQ1NoZkdjY00vd2ZSbGVpOVV0ejZwOVAKWFJLSWxXblh0VDRxTkdaTlROMHRSK05MRy82QnFkOE9ZQmFGQVVjdWUvdzFWVzZKUTJWR1laSG5adTlTOExNYwpGWUJhNUlnOVB4d0dRT2dxNlJES0RiVitQcVRRVDVFRk1lUjFtcmpja2s0RFFKamJ4ZU1aYmlOTUc1a0dFQ0E4CmczODNQM2VsaG4wM1dHYkVFYTRNTmMzWjQrN2MyMzZRSTN4V0pmTlBkVWJYUmFBd2h5LzZyVFNGYnp3S0IwSm0KZWJ3elFmd2pRWTZmNTVNaUkvUnFEQ3l1UGozcjNqeVZSa0s4NnBRS0JBSndGSHlxajlLYUtYTVpqZlZub3dMaAo5c3ZJR2ZOYkdIcHVjQVRxUkV2VUh1UWJObnFrQ3g4VlZodFlraERiOWZFUDJ4QnU1VnZIYlIrM25mVmhNdXQ1CkczNEN0NVJTN0p0NkxJZkZkdGNuOENhU2FzL2wxSGJpR2VSZ2M3MFgvOWFZeC9WL0NFSnYwbEllOGdQNnVEb1cKRlBJWjdkNnZIK1ZybzZ4dVdFR2l1TWFpem5hcDJLaFptcGtnZnVweUZtcGxoMHM2a255bXVRSU5CRml0MmlvQgpFQURuZUw5UzltNHZoVTNibGFSalZVVXlKN2IvcVRqY1N5bHZDSDVYVUU2UjJrK2NrRVpqZkFNWlBMcE8rL3RGCk0ySklKTUQ0U2lmS3VTM3hjazlLdFpHQ3VmR21jd2lMUVJ6ZUhGN3ZKVUtyTEQ1UlRrTmkyM3lkdldaZ1BqdHgKUStEVFQxWmNuN0JyUUZZNkZnblJvVVZJeHd0ZHcxYk1ZLzg5cnNGZ1M1d3d1TUVTZDNRMlJZZ2I3RU9GT3BudQp3NmRhN1dha1dmNElobkY1bnNOWUdEVmFJSHpwaXFDbCt1VGJmMWVwQ2pyT2xJemtaM1ozWWs1Q00vVGlGelBrCnoybEx6ODljcEQ4VStOdENzZmFnV1dmamQyVTNqRGFwZ0grN25RbkNFV3BST3R6YUtIRzZsQTNwWGRpeDV6RzgKZVJjNi8wSWJVU1d2ZmpLeExMUGZOZUNTMnBDTDNJZUVJNW5vdGhFRVlkUUg2c3pwTG9nNzl4QjlkVm5KeUtKYgpWZnhYbnNlb1lxVnJSejJWVmJVSTVCbHdtNkI0MEUzZUdWZlVRV2l1eDU0RHNweVZNTWs0MU14N1FKM2l5bklhCjFONFpBcVZNQUVydXlYVFJUeGM5WFcwdFloRE1BLzFHWXZ6MEVtRnBtOEx6VEhBNnNGVnRQbS9abE5DWDZQMVgKekp3cnY3RFNRS0Q2R0dsQlFVWCtPZUVKOHRUa2tmOFFUSlNQVWRoOFA4WXhERlM1RU9HQXZoaHBNQllENDJrUQpwcVhqRUMrWGN5Y1R2R0k3aW1wZ3Y5UERZMVJDQzF6a0JqS1BhMTIwck5odi9oa1ZrL1lodUdvYWpvSHl5NGg3ClpRb3BkY010cE4yZGdtaEVlZ255OUpDU3d4ZlFtUTB6SzBnN202U0hpS013andBUkFRQUJpUVErQkJnQkNBQUoKQlFKWXJkb3FBaHNDQWlrSkVJMkJnRHdPdjgySXdWMGdCQmtCQ0FBR0JRSllyZG9xQUFvSkVINmdxY1B5Yy96WQoxV0FQLzJ3SitSMGdFNnFzY2UzcmphSXo1OFBKbWM4Z29LcmlyNWhuRWxXaFBnYnE3Y1lJc1c1cWlGeUxoa2RwClljTW1oRDltUmlQcFFuNllhMnczZTNCOHpmSVZLaXBiTUJua2UveXRaOU03cUhtRENjam9pU213RVhOM3dLWUkKbUQ5VkhPTnNsL0NHMXJVOUlzdzFqdEI1ZzFZeHVCQTdNL20zNlhONngydStOdE5NREI5UDU2eWM0Z2ZzWlZFUwpLQTl2K3lZMi9sNDVMOGQvV1VrVWkwWVhvbW42aHlCR0k3SnJCTHEwQ1gzN0dFWVA2TzlycktpcGZ6NzNYZk83CkpJR3pPS1psbGpiL0Q5UlgvZzduUmJDbiszRXRIN3huaytUSy81MGV1RUt3OFNNVWcxNDdzSlRjcFFtdjZVeloKY000SmdMMEhiSFZDb2pWNEMvcGxFTHdNZGRBTE9GZVlRelRpZjZzTVJQZiszRFNqOGZyYkluakNoQzN5T0x5MAo2YnI5MktGb20xN0VJajJDQWNvZXE3VVBoaTJvb3VZQndQeGg1eXRkZWhKa29vK3NON1JJV3VhNlAyV1Ntb241ClU4ODhjU3lsWEMwK0FERmRnTFg5SzJ6ckRWWVVHMXZvOENYMHZ6eEZCYUh3TjZQeDI2ZmhJVDEvaFlVSFFSMXoKVmZORGN5UW1YcWtPblp2dm9NZnovUTBzOUJoRkovelU2QWdRYklaRS9obTFzcHNmZ3Z0c0QxZnJaZnlnWEo5ZgppclArTVNBSTgweEhTZjkxcVNSWk9qNFBsM1pKTmJxNHlZeHYwYjFwa01xZUdkamRDWWhMVStMWjR3YlFtcENrClNWZTJwcmxMdXJlaWdYdG1aZmtxZXZSejdGcklaaXU5a3k4d25DQVB3Qzcvem1TMThyZ1AvMTdiT3RMNC9pSXoKUWh4QUFvQU1XVnJHeUppdlNramhTR3gxdUNvanNXZnNUQW0xMVA3anNydUlMNjFaek1VVkUyYU0zUG1qNUcrVwo5QWNaNThFbSsxV3NWbkFYZFVSLy9iTW1oeXI4d0wvRzFZTzFWM0pFSlRSZHhzU3hkWWE0ZGVHQkJZL0FkcHN3CjI0anhoT0pSK2xzSnBxSVVlYjk5OStSOGV1RGhSSEc5ZUZPN0RSdTZ3ZWF0VUo2c3V1cG9EVFJXdHIvNHlHcWUKZEt4VjNxUWhOTFNuYUF6cVcvMW5BM2lVQjRrN2tDYUtaeGhkaERiQ2xmOVAzN3FhUlc0NjdCTENWTy9jb0wzeQpWbTUwZHdkck50S3BNQmgzWnBiQjF1SnZnaTltWHR5Qk9NSjN2OFJaZUR6RmlHOEhkQ3RnOVJ2SXQvQUlGb0hSCkgzUytVNzlOVDZpMEtQekxJbURmczhUN1JscHl1TWM0VWZzOGdneWc5djNBZTZjTjNlUXl4Y0szdzBjYkJ3c2gKL25RTmZzQTZ1dSs5SDdOaGJlaEJNaFlucE5aeXJIekNtenlYa2F1d1JBcW9DYkdDTnlrVFJ3c3VyOWdTNDFUUQpNOHNzRDFqRmhlT0pmM2hPRG5rS1UrSEtqdk1ST2wxREs3emRtTGROekExY3Z0WkgvbkNDOUtQajF6OFFDNDdTCnh4K2RUWlN4NE9OQWh3YlMvTE4zUG9LdG44TFBqWTlOUDl1RFdJK1RXWXF1UzJVK0tIRHJCRGxzZ296RGJzL08KakN4Y3BEek5tWHBXUUhFdEhVNzY0OU9YSFA3VWVOU1QxbUNVQ0g1cWRhbmswVjFpZWpGNi9DZlRGVTRNZmNyRwpZVDkwcUZGOTNNM3YwMUJieFArRUlZMi85dGlJUGJyZAo9MFlZaAotLS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCg=="; \
  GPG_KEY_FILE="/usr/share/keyrings/docker.gpg"; \
  printf "%s" "${GPG_KEY}" | base64 -d | gpg --batch --dearmor --output "${GPG_KEY_FILE}"; \
  printf "deb [arch=%s signed-by=%s] https://download.docker.com/linux/ubuntu %s stable\n" "$(dpkg --print-architecture)" "${GPG_KEY_FILE}" "$(. /etc/os-release && printf "%s" "${VERSION_CODENAME}")" | tee /etc/apt/sources.list.d/docker.list; \
  apt-get -qq update; \
  apt-get -qqy --no-install-recommends install \
  docker-ce-cli="5:${DOCKER_VERSION}*"; \
  docker --version; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="amd64";; linux/arm64) ARCH="arm64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  mkdir -p /usr/local/lib/docker/cli-plugins; \
  curl -fsSLo /usr/local/lib/docker/cli-plugins/docker-buildx "https://github.com/docker/buildx/releases/download/v${DOCKER_BUILDX_VERSION}/buildx-v${DOCKER_BUILDX_VERSION}.linux-${ARCH}"; \
  chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx; \
  docker buildx version; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="x86_64";; linux/arm64) ARCH="aarch64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  curl -fsSLo /usr/local/lib/docker/cli-plugins/docker-compose "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-${ARCH}"; \
  chmod +x /usr/local/lib/docker/cli-plugins/docker-compose; \
  docker compose version;

# renovate: datasource=git-tags depName=https://github.com/kubernetes/kubernetes extractVersion=v(?<version>.+)$
ARG KUBECTL_VERSION="1.33.3"
RUN --mount=type=cache,target=/var/lib/apt,sharing=locked --mount=type=tmpfs,target=/var/log set -eux; \
  # GPG_KEY="$(curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | base64 -w 0)"; \
  GPG_KEY="LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tClZlcnNpb246IEdudVBHIHYxLjQuNSAoR05VL0xpbnV4KQoKbVFFTkJHTUhvWGNCQ0FEdWtHT0VReWxlVmlPZ3RrTVZhN2hLaWZQNlBPQ1RoKzk4eE5XNFRmSEsvbkJKTjJzbQp1NFhhaVVtdEI5VXVHdDlqbDhWeFFnNGhPTVJmNDBjb0l3SHNOd3RTcmMyUjl2NUtncHZjdjUzN1FWSWlnVkhICldNTnZYZW9aa2tvRElVbGp2YkNFRFdhRWhTOVI1T01ZS2Q0QWFKK2YxYzhPRUxoRWNWMmRBUUxMeWp0bkVhRi8KcW1SRU4rM1k5KzVWY1JadlFIZXlCeENHK2hkVUdFNzQwaXhnblkyZ1NxWi9KNFllUW50UTZwTVVFaFQ2cGJhRQoxMHEySFVpZXJqL2ltMFYrWlVkQ2g0NkxrL1JkZmE1WktscVlPaUEyaU4xY29EUElkeXFLYXZjZGZQcVNyYUtGCkxhbjJLTGNaY2dUeFArMCtIZnpLZWZ2R0VuWmExMWNpdmJlOUFCRUJBQUcwUG1semRqcHJkV0psY201bGRHVnoKSUU5Q1V5QlFjbTlxWldOMElEeHBjM1k2YTNWaVpYSnVaWFJsYzBCaWRXbHNaQzV2Y0dWdWMzVnpaUzV2Y21jKwppUUUrQkJNQkNBQW9CUUpuRkYzNEFoc0RCUWtJSzJ5QkJnc0pDQWNEQWdZVkNBSUpDZ3NFRmdJREFRSWVBUUlYCmdBQUtDUkFqUmxUYW1pbGtOdE9BQ0FDREs5ZFE4Q0gySmk5QzNROTI2blZNVWlYZHlKSzFvbkNCclFTRUJxZFIKTEphVDZoR3g1cHp4a1FHZ1VEcFM5cDdMQTB1OTIwSEtMd0diN3lJQVd0eUU1VEFqMkNZcHJHZ3BxOThzZnNHQworVTVUOUlyQWR5YS9CYVRBa2tQNmdOaGZNak5hSzNiT1dzdnVMUmxsdUtNTmNoNGlmeStJd0xxYzFKTEc0MGJqCjJIbktCR1lrQzNtMFZ0UWZVdVBRTUltU0x0YS9Od1JISk1QbzhqZkd5TWFucU1NeHAzNS9lY1AyclhNZmIvbDEKV2pGRFk3aCs2bnFYYXkyMGxqTVhrTjIzVzh3RlRkdkM2bHE0NXd3TTVJQm5LTlIvVGpOTllBSWl6Wm9IRld6MQpjL2VjTVdXV0NCMlM3V2JZNHhJM0pTQ09ENFhJZmYzaWU3cGM2OC9rZ1B5dGlRSWNCQk1CQWdBR0JRSmpCNkYzCkFBb0pFTThMa296ZTFrODczVFFQLzB0MkYvamx0TFJRTUc3VkNMdzcrcHM1SkNXNUZJcXUvUzJpOWdTZE5BMEUKNDJ1K0x5eGpHM1l4bVZvVlJNc3hldTRrRXJ4cjhiTGNBNHA3MVcvbktlcXdGOVZMdVhLaXJzQkM3ejJzeUZpTApOZGwwQVJuQzNFTnd1TVZsU0N3Sk8wTU01TmlKdUxPcU9HWXlEMVh6U2ZuQ3prWE4wSkdBL2JmUFJTNW1QZm9XCjBPSElSWkZocUU3RUQ2d3lXcEhJS1Q4clhrRVNGd3N6VXdXL0Q3bzFIYWdYNytkdUx0OFdrcm9oR2J4VEoyMTUKWWFuT0tTcXlLZCs2WUd6RE5Vb0d1TU5QWko1d1RyVGhPa1R6RUZaNEhqbVExNnc1eG1jVUlTbkNaZDRuaHNiUwpxTi9VeVY5VnUzbG5rYXV0UzE1RTRDY2pQMVJSelNrVDBqa2E2MnZQdEF6dytQaUdyeU0xRjdzdnVSYUVuSkQ1CkdYemo5UkNVYVI2dnRGVnZxcW80ZnZiQTk5azRYWGorZEZBWFcwVFJaL2cyUU1lUFc5Y2RXaWVsY3IrdkhGNFoKMkVuc0FtZHZGN3I1ZTJKQ09VM044T1VvZGViVTZ3czRWZ1JWRzlncHRRZ2ZNUjB2Y2lCYk5ERzJYdWsxV0RrMQpxdHNjYmZtNUZWTDM2bzdka2pBMHgrVFlDdHFaSXI0eDNtbWZBWUZVcXp4cGZ5WGJTSHFVSlIyQ29XeGx5ejcyClhuSjdVRW8vMFViZ3pHenNjeExQRHlKSE1NNURuL05pOUZWVFZLbEFMSG5GT1lZU1RsdW9ZQUNGMURNdDdOSjMKb3lBME1FTEwwSlF6RWluaXhxeHBaMXRhT21WUi84cFFWcnFzdHF3cXNwM1JBQmFlWjgwSmJpZ1VDMjl6SlVWZgo9RXBsagotLS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCg=="; \
  GPG_KEY_FILE="/usr/share/keyrings/kubernetes.gpg"; \
  KUBERNETES_MAJOR_MINOR_VERSION="$(printf "%s" "${KUBECTL_VERSION}" | cut -d "." -f 1-2)"; \
  printf "%s" "${GPG_KEY}" | base64 -d | gpg --batch --dearmor --output "${GPG_KEY_FILE}"; \
  printf "deb [signed-by=%s] https://pkgs.k8s.io/core:/stable:/v%s/deb/ /\n" "${GPG_KEY_FILE}" "${KUBERNETES_MAJOR_MINOR_VERSION}" | tee /etc/apt/sources.list.d/kubernetes.list; \
  apt-get -qq update; \
  apt-get -qqy --no-install-recommends install \
  kubectl="${KUBECTL_VERSION}*"; \
  kubectl completion bash | tee /etc/bash_completion.d/kubectl; \
  kubectl version --client;

# renovate: datasource=git-tags depName=https://github.com/helm/helm extractVersion=v(?<version>.+)$
ARG HELM_VERSION="3.18.4"
RUN set -eux; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="amd64";; linux/arm64) ARCH="arm64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  curl -fsSLo bundle.tar.gz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz"; \
  tar -xf bundle.tar.gz -C /usr/local/bin --strip-components 1 "linux-${ARCH}/helm"; \
  rm bundle.tar.gz; \
  helm completion bash | tee /etc/bash_completion.d/helm; \
  helm version --short;

# renovate: datasource=git-tags depName=https://github.com/opentofu/opentofu extractVersion=v(?<version>.+)$
ARG TOFU_VERSION="1.10.5"
RUN --mount=type=tmpfs,target=/root/.terraform.d set -eux; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="amd64";; linux/arm64) ARCH="arm64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  curl -fsSLo bundle.tar.gz "https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_${ARCH}.tar.gz"; \
  tar -xf bundle.tar.gz -C /usr/local/bin tofu; \
  rm bundle.tar.gz; \
  printf "complete -C /usr/local/bin/tofu tofu\n" | tee /etc/bash_completion.d/tofu; \
  tofu -version;
  
# renovate: datasource=node-version depName=node
ARG NODE_VERSION="22.18.0"
# renovate: datasource=npm depName=npm
ARG NPM_VERSION="11.5.2"
ARG NODE_HOME="/usr/local/lib/node"
ENV PATH="${PATH}:${NODE_HOME}/bin"
RUN --mount=type=cache,target=/root/.npm --mount=type=tmpfs,target=/tmp set -eux; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="x64";; linux/arm64) ARCH="arm64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  mkdir -p "${NODE_HOME}"; \
  curl -fsSLo bundle.tar.gz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz"; \
  tar -xf bundle.tar.gz -C "${NODE_HOME}" --strip-components 1 --no-same-owner; \
  rm bundle.tar.gz; \
  node --completion-bash | tee /etc/bash_completion.d/node; \
  node --version; \
  npm install --global "npm@${NPM_VERSION}"; \
  npm completion | tee /etc/bash_completion.d/npm; \
  npm --version;

# renovate: datasource=git-tags depName=https://github.com/astral-sh/uv
ARG UV_VERSION="0.8.10"
ENV UV_LINK_MODE="copy"
RUN set -eux; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="x86_64";; linux/arm64) ARCH="aarch64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  curl -fsSLo bundle.tar.gz "https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-${ARCH}-unknown-linux-musl.tar.gz"; \
  tar -xf bundle.tar.gz -C /usr/local/bin --strip-components 1; \
  rm bundle.tar.gz; \
  uv generate-shell-completion bash | tee /etc/bash_completion.d/uv; \
  uv --version;

ARG PYTHON_VERSION="3.12"
ARG PYTHON_HOME="/usr/local/lib/python"
ENV PATH="${PATH}:${PYTHON_HOME}/bin"
RUN --mount=type=tmpfs,target=/tmp set -eux; \
  PYTHON_TMP_HOME="/tmp/python"; \
  uv python install "cpython@${PYTHON_VERSION}" --install-dir="${PYTHON_TMP_HOME}"; \
  mv "${PYTHON_TMP_HOME}"/cpython-*/ "${PYTHON_HOME}"; \
  python3 --version;

# renovate: datasource=git-tags depName=https://github.com/starship/starship extractVersion=v(?<version>.+)$
ARG STARSHIP_VERSION="1.23.0"
RUN --mount=type=cache,target=/root/.cache/starship set -eux; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="x86_64";; linux/arm64) ARCH="aarch64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  curl -fsSLo bundle.tar.gz "https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-${ARCH}-unknown-linux-musl.tar.gz"; \
  tar -xf bundle.tar.gz -C /usr/local/bin; \
  rm bundle.tar.gz; \
  printf "eval \"\$(starship init bash)\"\n" | tee /etc/skel/.bashrc.d/99-starship.sh; \
  mkdir -p /etc/skel/.config; \
  printf "[container]\ndisabled = true\n\n[hostname]\ndisabled = true\n\n[username]\ndisabled = true\n" | tee /etc/skel/.config/starship.toml; \
  starship --version;

# renovate: datasource=git-tags depName=https://github.com/coder/code-server extractVersion=v(?<version>.+)$
ARG VSCODE_SERVER_VERSION="4.103.0"
ARG VSCODE_SERVER_HOME="/usr/local/lib/vscode-server"
RUN --mount=type=tmpfs,target=/root/.config --mount=type=tmpfs,target=/root/.local set -eux; \
  case "${TARGETPLATFORM}" in linux/amd64) ARCH="amd64";; linux/arm64) ARCH="arm64";; *) printf "Unsupported target platform [%s]\n"; exit 1;; esac; \
  mkdir -p "${VSCODE_SERVER_HOME}"; \
  curl -fsSLo bundle.tar.gz "https://github.com/coder/code-server/releases/download/v${VSCODE_SERVER_VERSION}/code-server-${VSCODE_SERVER_VERSION}-linux-${ARCH}.tar.gz"; \
  tar -xf bundle.tar.gz -C "${VSCODE_SERVER_HOME}" --strip-components 1; \
  rm bundle.tar.gz; \
  /usr/local/lib/vscode-server/bin/code-server --version;

ARG USER_ID="65532"
ARG GROUP_ID="${USER_ID}"
ARG USER="nonroot"
ARG GROUP="${USER}"
RUN set -eux; \
  deluser --remove-all-files ubuntu; \
  addgroup --gid "${GROUP_ID}" "${GROUP}"; \
  adduser --disabled-password --gecos "" --home "/home/${USER}" --ingroup "${GROUP}" --shell "/bin/bash" --uid "${USER_ID}" "${USER}"; \
  printf "%s ALL=(ALL) NOPASSWD: ALL" "${USER}" | tee "/etc/sudoers.d/${USER}";

USER "${USER_ID}:${GROUP_ID}"

ARG DIRECTORIES="/home/nonroot/.cache /home/nonroot/.local/share/code-server /home/nonroot/workspace"
RUN set -eux; \
  for dir in ${DIRECTORIES}; do mkdir -p "${dir}"; done;

ENTRYPOINT ["/usr/local/lib/vscode-server/bin/code-server", "--auth=none", "--bind-addr=0.0.0.0:8080", "--disable-telemetry", "--disable-update-check"]
