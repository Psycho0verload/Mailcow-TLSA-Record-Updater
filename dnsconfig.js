/* Registrar */
var REG_NONE = NewRegistrar("none");
/* DNS Provider */
var DNS_BIND = NewDnsProvider("bind");

/* TLSA entries */
var tlsa = require('./tlsa_record.json');

D("example.com", REG_NONE, DnsProvider(DNS_BIND), NO_PURGE,
    AUTODNSSEC_ON,
    TLSA("_25._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),
    TLSA("_587._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),
    TLSA("_465._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),
    TLSA("_143._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),
    TLSA("_993._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),
    TLSA("_110._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),
    TLSA("_995._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),
    TLSA("_443._tcp.mail", 3, 1, 1, tlsa["mailserver"].cert_311),

    TLSA("_25._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
    TLSA("_587._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
    TLSA("_465._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
    TLSA("_143._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
    TLSA("_993._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
    TLSA("_110._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
    TLSA("_995._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
    TLSA("_443._tcp.mail", 3, 1, 2, tlsa["mailserver"].cert_312),
END)