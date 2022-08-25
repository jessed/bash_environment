" Vim syntax file
" Language:     BIG-IPv4 Configuration File
" Maintainer:   Jeffrey Hafey (F5 Networks, Engineering Services)
" Version:      1.0
"
"
" BIG-IPv4 Syntax Highlighting {{{1
syn sync fromstart

" comments {{{2
syn match BConfComment /^\s*#.*$/
" 2}}}

" keywords {{{2
" pool keywords {{{3
syn keyword BConfPoolKeywords lb_method min_active_members cookie_mode cookie_expiration persist ssl_timeout sip_timeout simple_timeout persist_mirror select header fallback clone pool ip_tos link_qos to snat nat member forward contained

  syn keyword BConfPoolSimpleKeywords simple simple_mask contained
  syn keyword BConfPoolStickyKewords sticky sticky_mask contained
  syn keyword BConfPoolCookieKeywords cookie hash cookie_name cookie_hash_offset cookie_hash_length contained
  syn keyword BConfPoolSSLKeywords ssl contained
  syn keyword BConfPoolSIPKeywords sip contained
  syn keyword BConfPoolMSRDPKeywords msrdp contained
  syn cluster BConfPoolPersist contains=BConfPoolSimpleKeywords,BConfPoolStickyKeywords,BConfPoolCookieKeywords,ConfPoolSSLKeywords,BConfPoolSIPKeywords,BConfMSRDPKeytwords

  syn keyword BConfPoolCloneKeywords before after contained
  syn cluster BConfPoolClone contains=BConfPoolCloneKeywords

  syn keyword BConfPoolTOSKeywords client server contained
  syn cluster BConfPoolTOS contains=BConfPoolTOSKeywords

  syn keyword BConfPoolMemberKeywords ratio priority contained
  syn cluster BConfPoolMember contains=BConfPoolMemberKeywords

syn cluster BConfPoolOptions contains=@BConfPoolClone,@BConfPoolTOS,@BConfPoolMember

" service keywords {{{3
syn keyword BConfServiceKeywords limit timeout contained

" virtual keywords {{{3
syn keyword BConfVirtualKeywords unit use netmask broadcast lasthop forward mirror conn svcdown_reset conn rebind syncookie_threshold translate accelerate timeout resets arp any_ip vlans contained

  syn keyword BConfVirtualUseKeywords pool rule contained
  syn cluster BConfVirtualUse contains=BConfVirtualUseKeywords

  syn keyword BConfVirtualXlateKeywords addr port contained
  syn cluster BConfVirtualXlate contains=BConfVirtualXlateKeywords

  syn cluster BConfVirtualOptions contains=@BConfVirtualUse,@BConfVirtualXlate

" node keywords {{{3
syn keyword BConfNodeKeywords limit dynamic_ratio monitor use contained

  syn keyword BConfNodeMonitorKeywords and contained
  syn cluster BConfNodeMonitor contains=BConfNodeMonitorKeywords

  syn cluster BConfNodeOptions contains=@BConfNodeMonitor

" self keywords {{{3
syn keyword BConfSelfKeywords vlan netmask broadcast unit floating snat automap contained

" interface keywords {{{3
syn keyword BConfInterfaceKeywords media duplex renames contained

  syn keyword BConfInterfaceDuplexKeywords full half auto none contained
  syn cluster BConfInterfaceDuplex contains=BConfInterfaceDuplexKeywords

  syn keyword BConfInterfaceMediaKeywords 100baseTX contained
  syn cluster BConfInterfaceMedia contains=BConfInterfaceMediaKeywords

  syn cluster BConfInterfaceOptions contains=@BConfInterfaceDuplex,@BConfInterfaceMedia

" vlan keywords {{{3
syn keyword BConfVlanKeywords tag interfaces add port_lockdown proxy_forward failsafe timeout snat automap mac_masq fdb mirror vlans contained

  syn keyword BConfVlanTaggedKeywords tagged contained
  syn cluster BConfVlanTagged contains=BConfVlanTaggedKeywords

  syn keyword BConfVlanFDBKeywords static dynamic interface contained
  syn cluster BConfVlanFDB contains=BConfVlanFDBKeywords

  syn keyword BConfVlanMirrorKeywords vlans hash contained
  syn cluster BConfVlanMirror contains=BConfVlanMirrorKeywords

  syn cluster BConfVlanOptions contains=@BConfVlanTagged,@BConfVlanFDB,@BConfVlanMirrorKeywords

" rule keywords {{{3
syn keyword BConfRuleKeywords redirect to contained

" nat keywords {{{3
syn keyword BConfNatKeywords unit arp vlans contained

" 3}}}

" ip/port/protocol/mac combinations including wildcard matches {{{3
syn match BConfMacAddress /\(\x\{2\}\:\)\{5\}\(\x\{2\}\)/ contained
syn match BConfIPAddress /\(\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\|\*\s\)/ contained
syn region BConfIPCombo matchgroup=BConfIPAddress start=/\(\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\.\d\{1,3\}\|\*[^- ]\)/ matchgroup=BConfIPService end=/\([a-z0-9\-]*\|\*\)\( \|$\)/ contained oneline
syn match BConfService /*\(\d\{1,5\}\s\|\*\s\)/ contained
syn keyword BConfProtocol tcp udp contained
" 3}}}
syn region BConfQuotedString start=/"/ end=/"/ contained
syn keyword BConfStatus enable disable up down contained
" 2}}}

" global configuration{{{2
syn region BConfGlobalConfig matchgroup=BConfKeyword start=/^global\s/ skip=/\s.*\s/me=e-1 matchgroup=BConfKeywordEnd end=/\s.*$/ oneline

" pool configuration {{{2
syn match BConfKeyword /^pool\s/ nextgroup=BConfPoolName
syn match BConfPoolName /\S*/ skipwhite contained nextgroup=BConfPoolConfig
syn region BConfPoolConfig start='{' end='}' contained contains=BConfPoolKeywords,@BConfPoolOptions,BConfIPAddress,BConfIPCombo

" service configuration {{{2
syn match BConfKeyword /^service\s/ nextgroup=BConfServiceConfig
syn match BConfServiceConfig /.*$/ skipwhite contained contains=BConfServiceKeywords,BConfProtocol,BConfStatus

" snat configuration {{{2
syn match BConfKeyword /^snat\s/

" rule configuration {{{2
syn match BConfKeyword /^rule\s/ nextgroup=BConfRuleName
syn match BConfRuleName /\S*/ skipwhite contained nextgroup=BConfRuleConfig
syn region BConfRuleConfig start='{' end='}' skipwhite contained contains=BConfRuleKeywords,BConfQuotedString

" virtual configuration {{{2
syn match BConfKeyword /^virtual\s/ nextgroup=BConfVirtual
syn match BConfVirtual /.*/ skipwhite contained contains=BConfVirtualConfig,BConfVirtualKeywords,BConfStatus
syn region BConfVirtualConfig start='{' end='}' contained contains=BConfVirtualKeywords,@BConfVirtualOptions,BConfStatus,BConfIPAddress,BConfIPCombo

" default_gateway {{{2
syn match BConfKeyword /^default_gateway/ skipwhite nextgroup=BConfDefaultGateway
syn match BConfDefaultGateway /\a.*/ contained contains=BConfKeywords

" nat configuration 
syn match BConfKeyword /^nat\s/
" TODO:
" nat { 172.30.184.1 to 151.193.166.30 unit 1 }

" class list configuration {{{2
syn match BConfKeyword /^class\s/
" class DAS-servers {
"     host 172.30.184.71
"     host 172.30.184.72
"     host 172.30.184.73
"     host 172.30.184.74
"     host 172.30.184.75
"     host 172.30.184.76
"     host 172.30.184.77
"     host 172.30.184.78
"     host 172.30.184.79
" }
" class MailServers {
"     host 172.30.184.242
"     host 172.30.184.243
"     host 172.30.184.250
"     host 172.30.184.251
" }
" class DAS-homepage-virtual {
"     host 151.193.165.41
" }
" class tp-node-select {
"     "p0200"
"     "p0211"
"     "p0212"
"     "p0213"
"     "p0214"
"     "p0215"
"     "p0216"
"     "p0217"
"     "p0428"
" }
" class cobrand-select {
"     "TCYFR"
" }
" class sslnode_select extern {
"     filename /config/sslNodeSelect
"     type string
"     mode readwrite
" }
" class node_select extern {
"     filename /config/NodeSelect
"     type string
"     mode readwrite
" }
" class pilot-select {
"     "T0010"
"     "T0063"
" }
syn match BConfKeyword /^proxy\s/
" proxy 151.193.166.10:443 unit 1 {
"    target virtual 127.193.166.10:443
"    clientssl enable
"    clientssl key travel.travelocity.com.key
"    clientssl cert travel.travelocity.com.crt
" }

" node configuration {{{2
syn match BConfKeyword /^node\s/ nextgroup=BConfNodeIP
syn match BConfNodeIP /[0-9\.\*]*\(\:\S*\)\?/ skipwhite skipnl contained contains=BConfIPAddress,BConfIPCombo nextgroup=BConfNodeIP,BConfNodeConfig
syn match BConfNodeConfig /\a.*/ skipwhite contained contains=BConfNodeKeywords,BConfStatus

" monitor configuration {{{2
syn match BConfKeyword /^monitor\s/ nextgroup=BConfMonitorName
syn match BConfMonitorName /\S*/ skipwhite contained nextgroup=BConfMonitorConfig
syn region BConfMonitorConfig matchgroup=BconfParen start='{' end='}' skipwhite contained contains=BConfMonitorKeywords

" interface configuration {{{2
syn match BConfKeyword /^interface\s/ nextgroup=BConfInterfaceName
syn match BConfInterfaceName /\S*/ skipwhite contained nextgroup=BConfInterfaceConfig
syn match BConfInterfaceConfig /.*$/ skipwhite contained contains=BConfInterfaceKeywords,@BConfInterfaceOptions

" self configuration {{{2
syn match BConfKeyword /^self\s/ nextgroup=BConfSelfName
syn match BConfSelfName /\S*/ skipwhite contained nextgroup=BConfSelfConfig
syn region BConfSelfConfig start='{' end='}' contained contains=BConfSelfKeywords,BConfIPAddress,BConfStatus

" vlan/vlangroup configuration {{{2
syn match BConfKeyword /^vlan\(group\)\?\s/ nextgroup=BConfVlanName
syn match BConfVlanName /\S*/ skipwhite contained nextgroup=BConfVlanConfig
syn region BConfVlanConfig start='{' end='}' contained contains=BConfVlanKeywords,@BConfVlanOptions,BConfStatus,BConfMacAddress

" snat/nat configuration {{{2
syn match BConfKeyword /^\(s\)\?nat\s\(map\s\)\?/ nextgroup=BConfNatConfig
syn region BConfNatConfig start='{' end='}' contained contains=BConfNatKeywords,BConfIPAddress,BConfStatus

" proxy configuration {{{2
" TODO:
" proxy 24.93.42.116:443 unit 2 {
"    target virtual 127.0.0.116:80
"    clientssl enable
"    clientssl key BIG-IP_webmail_phrrtx.key
"    clientssl cert BIG-IP_webmail_phrrtx-200605.crt
" }


" 2}}}

" highlighting {{{2
if version >= 508 || !exists("did_bigip_syn_inits")
  if version < 508
    let did_bigip_conf_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink BConfComment Comment

  " keywords
  HiLink BConfPoolKeywords Identifier
  HiLink BConfServiceKeywords Identifier
  HiLink BConfVirtualKeywords Identifier
  HiLink BConfVirtualUseKeywords Identifier
  HiLink BConfNodeKeywords Identifier
  HiLink BConfSelfKeywords Identifier
  HiLink BConfInterfaceKeywords Identifier
  HiLink BConfVlanKeywords Identifier
  HiLink BConfRuleKeywords Identifier
  HiLink BConfNatKeywords Identifier
  HiLink BConfProxyKeywords Identifier
  HiLink BConfProxySSLCliSer Identifier

  HiLink BConfPoolCloneKeywords Special
  HiLink BConfPoolTOSKeywords Special
  HiLink BConfPoolMemberKeywords Special
  HiLink BConfVirtualXlateKeywords Special
  HiLink BConfNodeMonitorKeywords Special
  HiLink BConfInterfaceMediaKeywords Special
  HiLink BConfInterfaceDuplexKeywords Special
  HiLink BConfVlanTaggedKeywords Special
  HiLink BConfVlanFDBKeywords Special
  HiLink BConfVlanMirrorKeywords Special
  HiLink BConfProxyTargetKeywords Special
  HiLink BConfProxySSLKeywords Special

  HiLink BConfProtocol Special

  HiLink BConfStatus Constant

  HiLink BConfKeyword Statement

  HiLink BConfKeywordEnd Constant

  HiLink BConfIPAddress Type
  HiLink BConfMacAddress Type
  HiLink BConfIPService Statement

  HiLink BConfQuotedString Constant

  delcommand HiLink
endif
" 2}}}

let b:current_syntax = "bigip_conf"
" 1}}}

" vim:sw=2 ts=2 fdm=marker
