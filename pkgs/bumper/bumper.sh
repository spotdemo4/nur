
# color support
reset_color=""
bold_color=""
info_color=""
warn_color=""
success_color=""

if colors=$(tput colors 2> /dev/null); then
    reset_color=$(tput sgr0)
    bold_color=$(tput bold)

    if [[ "$colors" -ge 256 ]]; then
        info_color=$(tput setaf 189)
        warn_color=$(tput setaf 216)
        success_color=$(tput setaf 117)
    fi
fi

function bold {
    printf "%s%s%s\n" "${bold_color}" "$1" "${reset_color}"
}

function info {
    printf "%s%s%s\n" "${info_color}" "$1" "${reset_color}"
}

function warn {
    printf "%s%s%s\n" "${warn_color}" "$1" "${reset_color}"
}

function success {
    printf "%s%s%s\n" "${success_color}" "$1" "${reset_color}"
}

if ! git diff --staged --quiet || ! git diff --quiet; then
    warn "please commit or stash changes before running bumper"
    exit 1
fi

# git info
git_branch=$(git rev-parse --abbrev-ref HEAD)
git_root=$(git rev-parse --show-toplevel)
git_version=$(git describe --tags "$(git rev-list --tags --max-count=1)")
files=$(git ls-files)

# get next version
version=${git_version#v}
major=$(echo "${version}" | cut -d . -f1)
minor=$(echo "${version}" | cut -d . -f2)
patch=$(echo "${version}" | cut -d . -f3)
case "${1-patch}" in
    major) 
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    minor) 
        minor=$((minor + 1))
        patch=0
        ;;
    patch) patch=$((patch + 1)) ;;
    *) echo "usage: bumper (major | minor | patch)" && exit ;;
esac
next_version="${major}.${minor}.${patch}"
echo "${version} -> ${next_version}"

# helper to replace version in a file
function replace {
    sed -i "s/${version}/${next_version}/g" "${1}"
    grep -q "${next_version}" "${1}"
}

# perform bumps
# node
if echo "${files}" | grep -i package.json; then
    info "bumping package.json"
    cd "${git_root}"
    if err=$(npm version "${next_version}" --no-git-tag-version > /dev/null); then
        git add package.json
        git add package-lock.json
    else
        warn "npm version failed: ${err}"
    fi
fi

# nix
if echo "${files}" | grep -i flake.nix; then
    info "bumping flake.nix"
    cd "${git_root}"
    if err=$(nix-update --flake --version "${next_version}" default > /dev/null); then
        git add flake.nix
    else
        warn "nix-update failed: ${err}"
    fi
fi

# openapi
echo "${files}" | grep -i "openapi.\(yml\|yaml\)" | while read -r openapi; do
    info "bumping ${openapi}"
    if replace "${openapi}"; then
        git add "${openapi}"
    fi
done

# readme
echo "${files}" | grep -i readme | while read -r readme; do
    info "bumping ${readme}"
    if replace "${readme}"; then
        git add "${readme}"
    fi
done

info "committing"
git commit -m "bump: v${version} -> v${next_version}"
git tag -a "v${next_version}" -m "bump: v${version} -> v${next_version}"

echo
success "bump successful, please push:"
bold "$(success "git push --atomic origin ${git_branch} v${next_version}")"
wl-copy "git push --atomic origin ${git_branch} v${next_version}" || true
echo