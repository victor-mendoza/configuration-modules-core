# ${license-info}
# ${developer-info}
# ${author-info}

declaration template components/spma/dnf/schema;

include 'components/spma/schema';

type component_spma_dnf = {
    include structure_component
    include component_spma_common
    "excludes"           ? string[] # packages to be excluded from metadata
    "dnfconf"            ? string   # /etc/dnf.conf DNF configuration
    "whitelist"          ? string[] # packages not shipped by repositories but generated by 3rd party installer
    "quattor_os_file"    ? string   # file to write quattor_os_release as confirmation of successful YUM spma pass
    "quattor_os_release" ? string   # string to write to quattor_os_file
    "proxy"              ? boolean  # Enable proxy
    "proxyhost"          ? string   # comma-separated list of proxy hosts
    "proxyport"          ? string   # proxy port number
    "proxyrandom"        ? boolean  # randomize proxyhost
    "proxytype"          ? string with match (SELF, '^(forward|reverse)$') # select proxy type, forward or reverse
    "run"                ? boolean  # Run the transaction after configuring DNF
};

bind "/software/components/spma" = component_spma_dnf;
