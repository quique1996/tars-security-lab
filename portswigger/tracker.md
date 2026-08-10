# PortSwigger Web Security Academy - TRACKER

Fuente oficial: <https://portswigger.net/web-security/all-labs>

**Total labs: 274** | hecho: 2 | en-progreso: 0 | pendiente: 272

Estados validos: `pendiente` `en-progreso` `hecho`

Cambiar estado (NO editar a mano, regenera este fichero):

```bash
/opt/portswigger/start-lab.sh status sqli 1 hecho
/opt/portswigger/start-lab.sh sqli 1        # abrir/preparar el lab
/opt/portswigger/start-lab.sh list sqli     # listar una categoria
```

## Indice de categorias

| Categoria | Slug | Labs | Hecho | Pendiente |
|---|---|---:|---:|---:|
| SQL injection | `sqli` | 18 | 1 | 17 |
| Cross-site scripting | `xss` | 30 | 1 | 29 |
| Cross-site request forgery (CSRF) | `csrf` | 12 | 0 | 12 |
| Clickjacking | `clickjacking` | 5 | 0 | 5 |
| DOM-based vulnerabilities | `dom-based` | 7 | 0 | 7 |
| Cross-origin resource sharing (CORS) | `cors` | 3 | 0 | 3 |
| XML external entity (XXE) injection | `xxe` | 9 | 0 | 9 |
| Server-side request forgery (SSRF) | `ssrf` | 7 | 0 | 7 |
| HTTP request smuggling | `request-smuggling` | 22 | 0 | 22 |
| OS command injection | `os-command-injection` | 5 | 0 | 5 |
| Server-side template injection | `ssti` | 7 | 0 | 7 |
| Path traversal | `path-traversal` | 6 | 0 | 6 |
| Access control vulnerabilities | `idor` | 13 | 0 | 13 |
| Authentication | `auth` | 14 | 0 | 14 |
| WebSockets | `websockets` | 3 | 0 | 3 |
| Web cache poisoning | `web-cache-poisoning` | 13 | 0 | 13 |
| Insecure deserialization | `deserialization` | 10 | 0 | 10 |
| Information disclosure | `info-disclosure` | 5 | 0 | 5 |
| Business logic vulnerabilities | `business-logic` | 12 | 0 | 12 |
| HTTP Host header attacks | `host-header` | 7 | 0 | 7 |
| OAuth authentication | `oauth` | 6 | 0 | 6 |
| File upload vulnerabilities | `file-upload` | 7 | 0 | 7 |
| JWT | `jwt` | 8 | 0 | 8 |
| Essential skills | `essential-skills` | 2 | 0 | 2 |
| Prototype pollution | `prototype-pollution` | 10 | 0 | 10 |
| GraphQL API vulnerabilities | `graphql` | 5 | 0 | 5 |
| Race conditions | `race-conditions` | 6 | 0 | 6 |
| NoSQL injection | `nosql` | 4 | 0 | 4 |
| API testing | `api-testing` | 5 | 0 | 5 |
| Web LLM attacks | `llm-attacks` | 8 | 0 | 8 |
| Web cache deception | `web-cache-deception` | 5 | 0 | 5 |

---

## SQL injection (`sqli`) - 18 labs [1/18 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `sqli-01` | APPRENTICE | [x] SQL injection vulnerability in WHERE clause allowing retrieval of hidden data | `hecho` | [abrir](https://portswigger.net/web-security/sql-injection/lab-retrieve-hidden-data) |
| 2 | `sqli-02` | APPRENTICE | [ ] SQL injection vulnerability allowing login bypass | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/lab-login-bypass) |
| 3 | `sqli-03` | PRACTITIONER | [ ] SQL injection attack, querying the database type and version on Oracle | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/examining-the-database/lab-querying-database-version-oracle) |
| 4 | `sqli-04` | PRACTITIONER | [ ] SQL injection attack, querying the database type and version on MySQL and Microsoft | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/examining-the-database/lab-querying-database-version-mysql-microsoft) |
| 5 | `sqli-05` | PRACTITIONER | [ ] SQL injection attack, listing the database contents on non-Oracle databases | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/examining-the-database/lab-listing-database-contents-non-oracle) |
| 6 | `sqli-06` | PRACTITIONER | [ ] SQL injection attack, listing the database contents on Oracle | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/examining-the-database/lab-listing-database-contents-oracle) |
| 7 | `sqli-07` | PRACTITIONER | [ ] SQL injection UNION attack, determining the number of columns returned by the query | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/union-attacks/lab-determine-number-of-columns) |
| 8 | `sqli-08` | PRACTITIONER | [ ] SQL injection UNION attack, finding a column containing text | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/union-attacks/lab-find-column-containing-text) |
| 9 | `sqli-09` | PRACTITIONER | [ ] SQL injection UNION attack, retrieving data from other tables | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/union-attacks/lab-retrieve-data-from-other-tables) |
| 10 | `sqli-10` | PRACTITIONER | [ ] SQL injection UNION attack, retrieving multiple values in a single column | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/union-attacks/lab-retrieve-multiple-values-in-single-column) |
| 11 | `sqli-11` | PRACTITIONER | [ ] Blind SQL injection with conditional responses | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/blind/lab-conditional-responses) |
| 12 | `sqli-12` | PRACTITIONER | [ ] Blind SQL injection with conditional errors | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/blind/lab-conditional-errors) |
| 13 | `sqli-13` | PRACTITIONER | [ ] Visible error-based SQL injection | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/blind/lab-sql-injection-visible-error-based) |
| 14 | `sqli-14` | PRACTITIONER | [ ] Blind SQL injection with time delays | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/blind/lab-time-delays) |
| 15 | `sqli-15` | PRACTITIONER | [ ] Blind SQL injection with time delays and information retrieval | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/blind/lab-time-delays-info-retrieval) |
| 16 | `sqli-16` | PRACTITIONER | [ ] Blind SQL injection with out-of-band interaction | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/blind/lab-out-of-band) |
| 17 | `sqli-17` | PRACTITIONER | [ ] Blind SQL injection with out-of-band data exfiltration | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/blind/lab-out-of-band-data-exfiltration) |
| 18 | `sqli-18` | PRACTITIONER | [ ] SQL injection with filter bypass via XML encoding | `pendiente` | [abrir](https://portswigger.net/web-security/sql-injection/lab-sql-injection-with-filter-bypass-via-xml-encoding) |

## Cross-site scripting (`xss`) - 30 labs [1/30 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `xss-01` | APPRENTICE | [ ] Reflected XSS into HTML context with nothing encoded | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/reflected/lab-html-context-nothing-encoded) |
| 2 | `xss-02` | APPRENTICE | [ ] Stored XSS into HTML context with nothing encoded | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/stored/lab-html-context-nothing-encoded) |
| 3 | `xss-03` | APPRENTICE | [ ] DOM XSS in document.write sink using source location.search | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-document-write-sink) |
| 4 | `xss-04` | APPRENTICE | [ ] DOM XSS in innerHTML sink using source location.search | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-innerhtml-sink) |
| 5 | `xss-05` | APPRENTICE | [ ] DOM XSS in jQuery anchor href attribute sink using location.search source | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-jquery-href-attribute-sink) |
| 6 | `xss-06` | APPRENTICE | [ ] DOM XSS in jQuery selector sink using a hashchange event | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-jquery-selector-hash-change-event) |
| 7 | `xss-07` | APPRENTICE | [ ] Reflected XSS into attribute with angle brackets HTML-encoded | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-attribute-angle-brackets-html-encoded) |
| 8 | `xss-08` | APPRENTICE | [ ] Stored XSS into anchor href attribute with double quotes HTML-encoded | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-href-attribute-double-quotes-html-encoded) |
| 9 | `xss-09` | APPRENTICE | [ ] Reflected XSS into a JavaScript string with angle brackets HTML encoded | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-javascript-string-angle-brackets-html-encoded) |
| 10 | `xss-10` | PRACTITIONER | [ ] DOM XSS in document.write sink using source location.search inside a select element | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-document-write-sink-inside-select-element) |
| 11 | `xss-11` | PRACTITIONER | [ ] DOM XSS in AngularJS expression with angle brackets and double quotes HTML-encoded | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-angularjs-expression) |
| 12 | `xss-12` | PRACTITIONER | [ ] Reflected DOM XSS | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-dom-xss-reflected) |
| 13 | `xss-13` | PRACTITIONER | [ ] Stored DOM XSS | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/dom-based/lab-dom-xss-stored) |
| 14 | `xss-14` | PRACTITIONER | [ ] Reflected XSS into HTML context with most tags and attributes blocked | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-html-context-with-most-tags-and-attributes-blocked) |
| 15 | `xss-15` | PRACTITIONER | [ ] Reflected XSS into HTML context with all tags blocked except custom ones | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-html-context-with-all-standard-tags-blocked) |
| 16 | `xss-16` | PRACTITIONER | [ ] Reflected XSS with some SVG markup allowed | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-some-svg-markup-allowed) |
| 17 | `xss-17` | PRACTITIONER | [ ] Reflected XSS in canonical link tag | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-canonical-link-tag) |
| 18 | `xss-18` | PRACTITIONER | [ ] Reflected XSS into a JavaScript string with single quote and backslash escaped | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-javascript-string-single-quote-backslash-escaped) |
| 19 | `xss-19` | PRACTITIONER | [ ] Reflected XSS into a JavaScript string with angle brackets and double quotes HTML-encoded and single quotes escaped | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-javascript-string-angle-brackets-double-quotes-encoded-single-quotes-escaped) |
| 20 | `xss-20` | PRACTITIONER | [ ] Stored XSS into onclick event with angle brackets and double quotes HTML-encoded and single quotes and backslash escaped | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-onclick-event-angle-brackets-double-quotes-html-encoded-single-quotes-backslash-escaped) |
| 21 | `xss-21` | PRACTITIONER | [ ] Reflected XSS into a template literal with angle brackets, single, double quotes, backslash and backticks Unicode-escaped | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-javascript-template-literal-angle-brackets-single-double-quotes-backslash-backticks-escaped) |
| 22 | `xss-22` | PRACTITIONER | [ ] Exploiting cross-site scripting to steal cookies | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/exploiting/lab-stealing-cookies) |
| 23 | `xss-23` | PRACTITIONER | [ ] Exploiting cross-site scripting to capture passwords | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/exploiting/lab-capturing-passwords) |
| 24 | `xss-24` | PRACTITIONER | [ ] Exploiting XSS to bypass CSRF defenses | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/exploiting/lab-perform-csrf) |
| 25 | `xss-25` | EXPERT | [ ] Reflected XSS with AngularJS sandbox escape without strings | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/client-side-template-injection/lab-angular-sandbox-escape-without-strings) |
| 26 | `xss-26` | EXPERT | [ ] Reflected XSS with AngularJS sandbox escape and CSP | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/client-side-template-injection/lab-angular-sandbox-escape-and-csp) |
| 27 | `xss-27` | EXPERT | [ ] Reflected XSS with event handlers and href attributes blocked | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-event-handlers-and-href-attributes-blocked) |
| 28 | `xss-28` | EXPERT | [ ] Reflected XSS in a JavaScript URL with some characters blocked | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/contexts/lab-javascript-url-some-characters-blocked) |
| 29 | `xss-29` | PRACTITIONER | [ ] Reflected XSS protected by very strict CSP, with dangling markup attack | `pendiente` | [abrir](https://portswigger.net/web-security/cross-site-scripting/content-security-policy/lab-very-strict-csp-with-dangling-markup-attack) |
| 30 | `xss-30` | EXPERT | [x] Reflected XSS protected by CSP, with CSP bypass | `hecho` | [abrir](https://portswigger.net/web-security/cross-site-scripting/content-security-policy/lab-csp-bypass) |

## Cross-site request forgery (CSRF) (`csrf`) - 12 labs [0/12 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `csrf-01` | APPRENTICE | [ ] CSRF vulnerability with no defenses | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/lab-no-defenses) |
| 2 | `csrf-02` | PRACTITIONER | [ ] CSRF where token validation depends on request method | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-token-validation/lab-token-validation-depends-on-request-method) |
| 3 | `csrf-03` | PRACTITIONER | [ ] CSRF where token validation depends on token being present | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-token-validation/lab-token-validation-depends-on-token-being-present) |
| 4 | `csrf-04` | PRACTITIONER | [ ] CSRF where token is not tied to user session | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-token-validation/lab-token-not-tied-to-user-session) |
| 5 | `csrf-05` | PRACTITIONER | [ ] CSRF where token is tied to non-session cookie | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-token-validation/lab-token-tied-to-non-session-cookie) |
| 6 | `csrf-06` | PRACTITIONER | [ ] CSRF where token is duplicated in cookie | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-token-validation/lab-token-duplicated-in-cookie) |
| 7 | `csrf-07` | PRACTITIONER | [ ] SameSite Lax bypass via method override | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-samesite-restrictions/lab-samesite-lax-bypass-via-method-override) |
| 8 | `csrf-08` | PRACTITIONER | [ ] SameSite Strict bypass via client-side redirect | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-samesite-restrictions/lab-samesite-strict-bypass-via-client-side-redirect) |
| 9 | `csrf-09` | PRACTITIONER | [ ] SameSite Strict bypass via sibling domain | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-samesite-restrictions/lab-samesite-strict-bypass-via-sibling-domain) |
| 10 | `csrf-10` | PRACTITIONER | [ ] SameSite Lax bypass via cookie refresh | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-samesite-restrictions/lab-samesite-strict-bypass-via-cookie-refresh) |
| 11 | `csrf-11` | PRACTITIONER | [ ] CSRF where Referer validation depends on header being present | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-referer-based-defenses/lab-referer-validation-depends-on-header-being-present) |
| 12 | `csrf-12` | PRACTITIONER | [ ] CSRF with broken Referer validation | `pendiente` | [abrir](https://portswigger.net/web-security/csrf/bypassing-referer-based-defenses/lab-referer-validation-broken) |

## Clickjacking (`clickjacking`) - 5 labs [0/5 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `clickjacking-01` | APPRENTICE | [ ] Basic clickjacking with CSRF token protection | `pendiente` | [abrir](https://portswigger.net/web-security/clickjacking/lab-basic-csrf-protected) |
| 2 | `clickjacking-02` | APPRENTICE | [ ] Clickjacking with form input data prefilled from a URL parameter | `pendiente` | [abrir](https://portswigger.net/web-security/clickjacking/lab-prefilled-form-input) |
| 3 | `clickjacking-03` | APPRENTICE | [ ] Clickjacking with a frame buster script | `pendiente` | [abrir](https://portswigger.net/web-security/clickjacking/lab-frame-buster-script) |
| 4 | `clickjacking-04` | PRACTITIONER | [ ] Exploiting clickjacking vulnerability to trigger DOM-based XSS | `pendiente` | [abrir](https://portswigger.net/web-security/clickjacking/lab-exploiting-to-trigger-dom-based-xss) |
| 5 | `clickjacking-05` | PRACTITIONER | [ ] Multistep clickjacking | `pendiente` | [abrir](https://portswigger.net/web-security/clickjacking/lab-multistep) |

## DOM-based vulnerabilities (`dom-based`) - 7 labs [0/7 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `dom-based-01` | PRACTITIONER | [ ] DOM XSS using web messages | `pendiente` | [abrir](https://portswigger.net/web-security/dom-based/controlling-the-web-message-source/lab-dom-xss-using-web-messages) |
| 2 | `dom-based-02` | PRACTITIONER | [ ] DOM XSS using web messages and a JavaScript URL | `pendiente` | [abrir](https://portswigger.net/web-security/dom-based/controlling-the-web-message-source/lab-dom-xss-using-web-messages-and-a-javascript-url) |
| 3 | `dom-based-03` | PRACTITIONER | [ ] DOM XSS using web messages and JSON.parse | `pendiente` | [abrir](https://portswigger.net/web-security/dom-based/controlling-the-web-message-source/lab-dom-xss-using-web-messages-and-json-parse) |
| 4 | `dom-based-04` | PRACTITIONER | [ ] DOM-based open redirection | `pendiente` | [abrir](https://portswigger.net/web-security/dom-based/open-redirection/lab-dom-open-redirection) |
| 5 | `dom-based-05` | PRACTITIONER | [ ] DOM-based cookie manipulation | `pendiente` | [abrir](https://portswigger.net/web-security/dom-based/cookie-manipulation/lab-dom-cookie-manipulation) |
| 6 | `dom-based-06` | EXPERT | [ ] Exploiting DOM clobbering to enable XSS | `pendiente` | [abrir](https://portswigger.net/web-security/dom-based/dom-clobbering/lab-dom-xss-exploiting-dom-clobbering) |
| 7 | `dom-based-07` | EXPERT | [ ] Clobbering DOM attributes to bypass HTML filters | `pendiente` | [abrir](https://portswigger.net/web-security/dom-based/dom-clobbering/lab-dom-clobbering-attributes-to-bypass-html-filters) |

## Cross-origin resource sharing (CORS) (`cors`) - 3 labs [0/3 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `cors-01` | APPRENTICE | [ ] CORS vulnerability with basic origin reflection | `pendiente` | [abrir](https://portswigger.net/web-security/cors/lab-basic-origin-reflection-attack) |
| 2 | `cors-02` | APPRENTICE | [ ] CORS vulnerability with trusted null origin | `pendiente` | [abrir](https://portswigger.net/web-security/cors/lab-null-origin-whitelisted-attack) |
| 3 | `cors-03` | PRACTITIONER | [ ] CORS vulnerability with trusted insecure protocols | `pendiente` | [abrir](https://portswigger.net/web-security/cors/lab-breaking-https-attack) |

## XML external entity (XXE) injection (`xxe`) - 9 labs [0/9 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `xxe-01` | APPRENTICE | [ ] Exploiting XXE using external entities to retrieve files | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/lab-exploiting-xxe-to-retrieve-files) |
| 2 | `xxe-02` | APPRENTICE | [ ] Exploiting XXE to perform SSRF attacks | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/lab-exploiting-xxe-to-perform-ssrf) |
| 3 | `xxe-03` | PRACTITIONER | [ ] Blind XXE with out-of-band interaction | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/blind/lab-xxe-with-out-of-band-interaction) |
| 4 | `xxe-04` | PRACTITIONER | [ ] Blind XXE with out-of-band interaction via XML parameter entities | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/blind/lab-xxe-with-out-of-band-interaction-using-parameter-entities) |
| 5 | `xxe-05` | PRACTITIONER | [ ] Exploiting blind XXE to exfiltrate data using a malicious external DTD | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/blind/lab-xxe-with-out-of-band-exfiltration) |
| 6 | `xxe-06` | PRACTITIONER | [ ] Exploiting blind XXE to retrieve data via error messages | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/blind/lab-xxe-with-data-retrieval-via-error-messages) |
| 7 | `xxe-07` | PRACTITIONER | [ ] Exploiting XInclude to retrieve files | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/lab-xinclude-attack) |
| 8 | `xxe-08` | PRACTITIONER | [ ] Exploiting XXE via image file upload | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/lab-xxe-via-file-upload) |
| 9 | `xxe-09` | EXPERT | [ ] Exploiting XXE to retrieve data by repurposing a local DTD | `pendiente` | [abrir](https://portswigger.net/web-security/xxe/blind/lab-xxe-trigger-error-message-by-repurposing-local-dtd) |

## Server-side request forgery (SSRF) (`ssrf`) - 7 labs [0/7 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `ssrf-01` | APPRENTICE | [ ] Basic SSRF against the local server | `pendiente` | [abrir](https://portswigger.net/web-security/ssrf/lab-basic-ssrf-against-localhost) |
| 2 | `ssrf-02` | APPRENTICE | [ ] Basic SSRF against another back-end system | `pendiente` | [abrir](https://portswigger.net/web-security/ssrf/lab-basic-ssrf-against-backend-system) |
| 3 | `ssrf-03` | PRACTITIONER | [ ] Blind SSRF with out-of-band detection | `pendiente` | [abrir](https://portswigger.net/web-security/ssrf/blind/lab-out-of-band-detection) |
| 4 | `ssrf-04` | PRACTITIONER | [ ] SSRF with blacklist-based input filter | `pendiente` | [abrir](https://portswigger.net/web-security/ssrf/lab-ssrf-with-blacklist-filter) |
| 5 | `ssrf-05` | PRACTITIONER | [ ] SSRF with filter bypass via open redirection vulnerability | `pendiente` | [abrir](https://portswigger.net/web-security/ssrf/lab-ssrf-filter-bypass-via-open-redirection) |
| 6 | `ssrf-06` | EXPERT | [ ] Blind SSRF with Shellshock exploitation | `pendiente` | [abrir](https://portswigger.net/web-security/ssrf/blind/lab-shellshock-exploitation) |
| 7 | `ssrf-07` | EXPERT | [ ] SSRF with whitelist-based input filter | `pendiente` | [abrir](https://portswigger.net/web-security/ssrf/lab-ssrf-with-whitelist-filter) |

## HTTP request smuggling (`request-smuggling`) - 22 labs [0/22 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `request-smuggling-01` | PRACTITIONER | [ ] HTTP request smuggling, confirming a CL.TE vulnerability via differential responses | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/finding/lab-confirming-cl-te-via-differential-responses) |
| 2 | `request-smuggling-02` | PRACTITIONER | [ ] HTTP request smuggling, confirming a TE.CL vulnerability via differential responses | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/finding/lab-confirming-te-cl-via-differential-responses) |
| 3 | `request-smuggling-03` | PRACTITIONER | [ ] Exploiting HTTP request smuggling to bypass front-end security controls, CL.TE vulnerability | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/exploiting/lab-bypass-front-end-controls-cl-te) |
| 4 | `request-smuggling-04` | PRACTITIONER | [ ] Exploiting HTTP request smuggling to bypass front-end security controls, TE.CL vulnerability | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/exploiting/lab-bypass-front-end-controls-te-cl) |
| 5 | `request-smuggling-05` | PRACTITIONER | [ ] Exploiting HTTP request smuggling to reveal front-end request rewriting | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/exploiting/lab-reveal-front-end-request-rewriting) |
| 6 | `request-smuggling-06` | PRACTITIONER | [ ] Exploiting HTTP request smuggling to capture other users' requests | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/exploiting/lab-capture-other-users-requests) |
| 7 | `request-smuggling-07` | PRACTITIONER | [ ] Exploiting HTTP request smuggling to deliver reflected XSS | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/exploiting/lab-deliver-reflected-xss) |
| 8 | `request-smuggling-08` | PRACTITIONER | [ ] Response queue poisoning via H2.TE request smuggling | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/advanced/response-queue-poisoning/lab-request-smuggling-h2-response-queue-poisoning-via-te-request-smuggling) |
| 9 | `request-smuggling-09` | PRACTITIONER | [ ] H2.CL request smuggling | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/advanced/lab-request-smuggling-h2-cl-request-smuggling) |
| 10 | `request-smuggling-10` | PRACTITIONER | [ ] HTTP/2 request smuggling via CRLF injection | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/advanced/lab-request-smuggling-h2-request-smuggling-via-crlf-injection) |
| 11 | `request-smuggling-11` | PRACTITIONER | [ ] HTTP/2 request splitting via CRLF injection | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/advanced/lab-request-smuggling-h2-request-splitting-via-crlf-injection) |
| 12 | `request-smuggling-12` | EXPERT | [ ] 0.CL request smuggling | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/advanced/lab-request-smuggling-0cl-request-smuggling) |
| 13 | `request-smuggling-13` | PRACTITIONER | [ ] CL.0 request smuggling | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/browser/cl-0/lab-cl-0-request-smuggling) |
| 14 | `request-smuggling-14` | PRACTITIONER | [ ] HTTP request smuggling, basic CL.TE vulnerability | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/lab-basic-cl-te) |
| 15 | `request-smuggling-15` | PRACTITIONER | [ ] HTTP request smuggling, basic TE.CL vulnerability | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/lab-basic-te-cl) |
| 16 | `request-smuggling-16` | PRACTITIONER | [ ] HTTP request smuggling, obfuscating the TE header | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/lab-obfuscating-te-header) |
| 17 | `request-smuggling-17` | EXPERT | [ ] Exploiting HTTP request smuggling to perform web cache poisoning | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/exploiting/lab-perform-web-cache-poisoning) |
| 18 | `request-smuggling-18` | EXPERT | [ ] Exploiting HTTP request smuggling to perform web cache deception | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/exploiting/lab-perform-web-cache-deception) |
| 19 | `request-smuggling-19` | EXPERT | [ ] Bypassing access controls via HTTP/2 request tunnelling | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/advanced/request-tunnelling/lab-request-smuggling-h2-bypass-access-controls-via-request-tunnelling) |
| 20 | `request-smuggling-20` | EXPERT | [ ] Web cache poisoning via HTTP/2 request tunnelling | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/advanced/request-tunnelling/lab-request-smuggling-h2-web-cache-poisoning-via-request-tunnelling) |
| 21 | `request-smuggling-21` | EXPERT | [ ] Client-side desync | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/browser/client-side-desync/lab-client-side-desync) |
| 22 | `request-smuggling-22` | EXPERT | [ ] Server-side pause-based request smuggling | `pendiente` | [abrir](https://portswigger.net/web-security/request-smuggling/browser/pause-based-desync/lab-server-side-pause-based-request-smuggling) |

## OS command injection (`os-command-injection`) - 5 labs [0/5 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `os-command-injection-01` | APPRENTICE | [ ] OS command injection, simple case | `pendiente` | [abrir](https://portswigger.net/web-security/os-command-injection/lab-simple) |
| 2 | `os-command-injection-02` | PRACTITIONER | [ ] Blind OS command injection with time delays | `pendiente` | [abrir](https://portswigger.net/web-security/os-command-injection/lab-blind-time-delays) |
| 3 | `os-command-injection-03` | PRACTITIONER | [ ] Blind OS command injection with output redirection | `pendiente` | [abrir](https://portswigger.net/web-security/os-command-injection/lab-blind-output-redirection) |
| 4 | `os-command-injection-04` | PRACTITIONER | [ ] Blind OS command injection with out-of-band interaction | `pendiente` | [abrir](https://portswigger.net/web-security/os-command-injection/lab-blind-out-of-band) |
| 5 | `os-command-injection-05` | PRACTITIONER | [ ] Blind OS command injection with out-of-band data exfiltration | `pendiente` | [abrir](https://portswigger.net/web-security/os-command-injection/lab-blind-out-of-band-data-exfiltration) |

## Server-side template injection (`ssti`) - 7 labs [0/7 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `ssti-01` | PRACTITIONER | [ ] Basic server-side template injection | `pendiente` | [abrir](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-basic) |
| 2 | `ssti-02` | PRACTITIONER | [ ] Basic server-side template injection (code context) | `pendiente` | [abrir](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-basic-code-context) |
| 3 | `ssti-03` | PRACTITIONER | [ ] Server-side template injection using documentation | `pendiente` | [abrir](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-using-documentation) |
| 4 | `ssti-04` | PRACTITIONER | [ ] Server-side template injection in an unknown language with a documented exploit | `pendiente` | [abrir](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-in-an-unknown-language-with-a-documented-exploit) |
| 5 | `ssti-05` | PRACTITIONER | [ ] Server-side template injection with information disclosure via user-supplied objects | `pendiente` | [abrir](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-with-information-disclosure-via-user-supplied-objects) |
| 6 | `ssti-06` | EXPERT | [ ] Server-side template injection in a sandboxed environment | `pendiente` | [abrir](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-in-a-sandboxed-environment) |
| 7 | `ssti-07` | EXPERT | [ ] Server-side template injection with a custom exploit | `pendiente` | [abrir](https://portswigger.net/web-security/server-side-template-injection/exploiting/lab-server-side-template-injection-with-a-custom-exploit) |

## Path traversal (`path-traversal`) - 6 labs [0/6 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `path-traversal-01` | APPRENTICE | [ ] File path traversal, simple case | `pendiente` | [abrir](https://portswigger.net/web-security/file-path-traversal/lab-simple) |
| 2 | `path-traversal-02` | PRACTITIONER | [ ] File path traversal, traversal sequences blocked with absolute path bypass | `pendiente` | [abrir](https://portswigger.net/web-security/file-path-traversal/lab-absolute-path-bypass) |
| 3 | `path-traversal-03` | PRACTITIONER | [ ] File path traversal, traversal sequences stripped non-recursively | `pendiente` | [abrir](https://portswigger.net/web-security/file-path-traversal/lab-sequences-stripped-non-recursively) |
| 4 | `path-traversal-04` | PRACTITIONER | [ ] File path traversal, traversal sequences stripped with superfluous URL-decode | `pendiente` | [abrir](https://portswigger.net/web-security/file-path-traversal/lab-superfluous-url-decode) |
| 5 | `path-traversal-05` | PRACTITIONER | [ ] File path traversal, validation of start of path | `pendiente` | [abrir](https://portswigger.net/web-security/file-path-traversal/lab-validate-start-of-path) |
| 6 | `path-traversal-06` | PRACTITIONER | [ ] File path traversal, validation of file extension with null byte bypass | `pendiente` | [abrir](https://portswigger.net/web-security/file-path-traversal/lab-validate-file-extension-null-byte-bypass) |

## Access control vulnerabilities (`idor`) - 13 labs [0/13 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `idor-01` | APPRENTICE | [ ] Unprotected admin functionality | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-unprotected-admin-functionality) |
| 2 | `idor-02` | APPRENTICE | [ ] Unprotected admin functionality with unpredictable URL | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-unprotected-admin-functionality-with-unpredictable-url) |
| 3 | `idor-03` | APPRENTICE | [ ] User role controlled by request parameter | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-user-role-controlled-by-request-parameter) |
| 4 | `idor-04` | APPRENTICE | [ ] User role can be modified in user profile | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-user-role-can-be-modified-in-user-profile) |
| 5 | `idor-05` | APPRENTICE | [ ] User ID controlled by request parameter | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-user-id-controlled-by-request-parameter) |
| 6 | `idor-06` | APPRENTICE | [ ] User ID controlled by request parameter, with unpredictable user IDs | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-user-id-controlled-by-request-parameter-with-unpredictable-user-ids) |
| 7 | `idor-07` | APPRENTICE | [ ] User ID controlled by request parameter with data leakage in redirect | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-user-id-controlled-by-request-parameter-with-data-leakage-in-redirect) |
| 8 | `idor-08` | APPRENTICE | [ ] User ID controlled by request parameter with password disclosure | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-user-id-controlled-by-request-parameter-with-password-disclosure) |
| 9 | `idor-09` | APPRENTICE | [ ] Insecure direct object references | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-insecure-direct-object-references) |
| 10 | `idor-10` | PRACTITIONER | [ ] URL-based access control can be circumvented | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-url-based-access-control-can-be-circumvented) |
| 11 | `idor-11` | PRACTITIONER | [ ] Method-based access control can be circumvented | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-method-based-access-control-can-be-circumvented) |
| 12 | `idor-12` | PRACTITIONER | [ ] Multi-step process with no access control on one step | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-multi-step-process-with-no-access-control-on-one-step) |
| 13 | `idor-13` | PRACTITIONER | [ ] Referer-based access control | `pendiente` | [abrir](https://portswigger.net/web-security/access-control/lab-referer-based-access-control) |

## Authentication (`auth`) - 14 labs [0/14 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `auth-01` | APPRENTICE | [ ] Username enumeration via different responses | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/password-based/lab-username-enumeration-via-different-responses) |
| 2 | `auth-02` | APPRENTICE | [ ] 2FA simple bypass | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/multi-factor/lab-2fa-simple-bypass) |
| 3 | `auth-03` | APPRENTICE | [ ] Password reset broken logic | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/other-mechanisms/lab-password-reset-broken-logic) |
| 4 | `auth-04` | PRACTITIONER | [ ] Username enumeration via subtly different responses | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/password-based/lab-username-enumeration-via-subtly-different-responses) |
| 5 | `auth-05` | PRACTITIONER | [ ] Username enumeration via response timing | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/password-based/lab-username-enumeration-via-response-timing) |
| 6 | `auth-06` | PRACTITIONER | [ ] Broken brute-force protection, IP block | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/password-based/lab-broken-bruteforce-protection-ip-block) |
| 7 | `auth-07` | PRACTITIONER | [ ] Username enumeration via account lock | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/password-based/lab-username-enumeration-via-account-lock) |
| 8 | `auth-08` | PRACTITIONER | [ ] 2FA broken logic | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/multi-factor/lab-2fa-broken-logic) |
| 9 | `auth-09` | PRACTITIONER | [ ] Brute-forcing a stay-logged-in cookie | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/other-mechanisms/lab-brute-forcing-a-stay-logged-in-cookie) |
| 10 | `auth-10` | PRACTITIONER | [ ] Offline password cracking | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/other-mechanisms/lab-offline-password-cracking) |
| 11 | `auth-11` | PRACTITIONER | [ ] Password reset poisoning via middleware | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/other-mechanisms/lab-password-reset-poisoning-via-middleware) |
| 12 | `auth-12` | PRACTITIONER | [ ] Password brute-force via password change | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/other-mechanisms/lab-password-brute-force-via-password-change) |
| 13 | `auth-13` | EXPERT | [ ] Broken brute-force protection, multiple credentials per request | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/password-based/lab-broken-brute-force-protection-multiple-credentials-per-request) |
| 14 | `auth-14` | EXPERT | [ ] 2FA bypass using a brute-force attack | `pendiente` | [abrir](https://portswigger.net/web-security/authentication/multi-factor/lab-2fa-bypass-using-a-brute-force-attack) |

## WebSockets (`websockets`) - 3 labs [0/3 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `websockets-01` | APPRENTICE | [ ] Manipulating WebSocket messages to exploit vulnerabilities | `pendiente` | [abrir](https://portswigger.net/web-security/websockets/lab-manipulating-messages-to-exploit-vulnerabilities) |
| 2 | `websockets-02` | PRACTITIONER | [ ] Cross-site WebSocket hijacking | `pendiente` | [abrir](https://portswigger.net/web-security/websockets/cross-site-websocket-hijacking/lab) |
| 3 | `websockets-03` | PRACTITIONER | [ ] Manipulating the WebSocket handshake to exploit vulnerabilities | `pendiente` | [abrir](https://portswigger.net/web-security/websockets/lab-manipulating-handshake-to-exploit-vulnerabilities) |

## Web cache poisoning (`web-cache-poisoning`) - 13 labs [0/13 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `web-cache-poisoning-01` | PRACTITIONER | [ ] Web cache poisoning with an unkeyed header | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-design-flaws/lab-web-cache-poisoning-with-an-unkeyed-header) |
| 2 | `web-cache-poisoning-02` | PRACTITIONER | [ ] Web cache poisoning with an unkeyed cookie | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-design-flaws/lab-web-cache-poisoning-with-an-unkeyed-cookie) |
| 3 | `web-cache-poisoning-03` | PRACTITIONER | [ ] Web cache poisoning with multiple headers | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-design-flaws/lab-web-cache-poisoning-with-multiple-headers) |
| 4 | `web-cache-poisoning-04` | PRACTITIONER | [ ] Targeted web cache poisoning using an unknown header | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-design-flaws/lab-web-cache-poisoning-targeted-using-an-unknown-header) |
| 5 | `web-cache-poisoning-05` | PRACTITIONER | [ ] Web cache poisoning via an unkeyed query string | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-implementation-flaws/lab-web-cache-poisoning-unkeyed-query) |
| 6 | `web-cache-poisoning-06` | PRACTITIONER | [ ] Web cache poisoning via an unkeyed query parameter | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-implementation-flaws/lab-web-cache-poisoning-unkeyed-param) |
| 7 | `web-cache-poisoning-07` | PRACTITIONER | [ ] Parameter cloaking | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-implementation-flaws/lab-web-cache-poisoning-param-cloaking) |
| 8 | `web-cache-poisoning-08` | PRACTITIONER | [ ] Web cache poisoning via a fat GET request | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-implementation-flaws/lab-web-cache-poisoning-fat-get) |
| 9 | `web-cache-poisoning-09` | PRACTITIONER | [ ] URL normalization | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-implementation-flaws/lab-web-cache-poisoning-normalization) |
| 10 | `web-cache-poisoning-10` | EXPERT | [ ] Web cache poisoning to exploit a DOM vulnerability via a cache with strict cacheability criteria | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-design-flaws/lab-web-cache-poisoning-to-exploit-a-dom-vulnerability-via-a-cache-with-strict-cacheability-criteria) |
| 11 | `web-cache-poisoning-11` | EXPERT | [ ] Combining web cache poisoning vulnerabilities | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-design-flaws/lab-web-cache-poisoning-combining-vulnerabilities) |
| 12 | `web-cache-poisoning-12` | EXPERT | [ ] Cache key injection | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-implementation-flaws/lab-web-cache-poisoning-cache-key-injection) |
| 13 | `web-cache-poisoning-13` | EXPERT | [ ] Internal cache poisoning | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-poisoning/exploiting-implementation-flaws/lab-web-cache-poisoning-internal) |

## Insecure deserialization (`deserialization`) - 10 labs [0/10 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `deserialization-01` | APPRENTICE | [ ] Modifying serialized objects | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-modifying-serialized-objects) |
| 2 | `deserialization-02` | PRACTITIONER | [ ] Modifying serialized data types | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-modifying-serialized-data-types) |
| 3 | `deserialization-03` | PRACTITIONER | [ ] Using application functionality to exploit insecure deserialization | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-using-application-functionality-to-exploit-insecure-deserialization) |
| 4 | `deserialization-04` | PRACTITIONER | [ ] Arbitrary object injection in PHP | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-arbitrary-object-injection-in-php) |
| 5 | `deserialization-05` | PRACTITIONER | [ ] Exploiting Java deserialization with Apache Commons | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-exploiting-java-deserialization-with-apache-commons) |
| 6 | `deserialization-06` | PRACTITIONER | [ ] Exploiting PHP deserialization with a pre-built gadget chain | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-exploiting-php-deserialization-with-a-pre-built-gadget-chain) |
| 7 | `deserialization-07` | PRACTITIONER | [ ] Exploiting Ruby deserialization using a documented gadget chain | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-exploiting-ruby-deserialization-using-a-documented-gadget-chain) |
| 8 | `deserialization-08` | EXPERT | [ ] Developing a custom gadget chain for Java deserialization | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-developing-a-custom-gadget-chain-for-java-deserialization) |
| 9 | `deserialization-09` | EXPERT | [ ] Developing a custom gadget chain for PHP deserialization | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-developing-a-custom-gadget-chain-for-php-deserialization) |
| 10 | `deserialization-10` | EXPERT | [ ] Using PHAR deserialization to deploy a custom gadget chain | `pendiente` | [abrir](https://portswigger.net/web-security/deserialization/exploiting/lab-deserialization-using-phar-deserialization-to-deploy-a-custom-gadget-chain) |

## Information disclosure (`info-disclosure`) - 5 labs [0/5 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `info-disclosure-01` | APPRENTICE | [ ] Information disclosure in error messages | `pendiente` | [abrir](https://portswigger.net/web-security/information-disclosure/exploiting/lab-infoleak-in-error-messages) |
| 2 | `info-disclosure-02` | APPRENTICE | [ ] Information disclosure on debug page | `pendiente` | [abrir](https://portswigger.net/web-security/information-disclosure/exploiting/lab-infoleak-on-debug-page) |
| 3 | `info-disclosure-03` | APPRENTICE | [ ] Source code disclosure via backup files | `pendiente` | [abrir](https://portswigger.net/web-security/information-disclosure/exploiting/lab-infoleak-via-backup-files) |
| 4 | `info-disclosure-04` | APPRENTICE | [ ] Authentication bypass via information disclosure | `pendiente` | [abrir](https://portswigger.net/web-security/information-disclosure/exploiting/lab-infoleak-authentication-bypass) |
| 5 | `info-disclosure-05` | PRACTITIONER | [ ] Information disclosure in version control history | `pendiente` | [abrir](https://portswigger.net/web-security/information-disclosure/exploiting/lab-infoleak-in-version-control-history) |

## Business logic vulnerabilities (`business-logic`) - 12 labs [0/12 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `business-logic-01` | APPRENTICE | [ ] Excessive trust in client-side controls | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-excessive-trust-in-client-side-controls) |
| 2 | `business-logic-02` | APPRENTICE | [ ] High-level logic vulnerability | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-high-level) |
| 3 | `business-logic-03` | APPRENTICE | [ ] Inconsistent security controls | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-inconsistent-security-controls) |
| 4 | `business-logic-04` | APPRENTICE | [ ] Flawed enforcement of business rules | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-flawed-enforcement-of-business-rules) |
| 5 | `business-logic-05` | PRACTITIONER | [ ] Low-level logic flaw | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-low-level) |
| 6 | `business-logic-06` | PRACTITIONER | [ ] Inconsistent handling of exceptional input | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-inconsistent-handling-of-exceptional-input) |
| 7 | `business-logic-07` | PRACTITIONER | [ ] Weak isolation on dual-use endpoint | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-weak-isolation-on-dual-use-endpoint) |
| 8 | `business-logic-08` | PRACTITIONER | [ ] Insufficient workflow validation | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-insufficient-workflow-validation) |
| 9 | `business-logic-09` | PRACTITIONER | [ ] Authentication bypass via flawed state machine | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-authentication-bypass-via-flawed-state-machine) |
| 10 | `business-logic-10` | PRACTITIONER | [ ] Infinite money logic flaw | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-infinite-money) |
| 11 | `business-logic-11` | PRACTITIONER | [ ] Authentication bypass via encryption oracle | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-authentication-bypass-via-encryption-oracle) |
| 12 | `business-logic-12` | EXPERT | [ ] Bypassing access controls using email address parsing discrepancies | `pendiente` | [abrir](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-bypassing-access-controls-using-email-address-parsing-discrepancies) |

## HTTP Host header attacks (`host-header`) - 7 labs [0/7 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `host-header-01` | APPRENTICE | [ ] Basic password reset poisoning | `pendiente` | [abrir](https://portswigger.net/web-security/host-header/exploiting/password-reset-poisoning/lab-host-header-basic-password-reset-poisoning) |
| 2 | `host-header-02` | APPRENTICE | [ ] Host header authentication bypass | `pendiente` | [abrir](https://portswigger.net/web-security/host-header/exploiting/lab-host-header-authentication-bypass) |
| 3 | `host-header-03` | PRACTITIONER | [ ] Web cache poisoning via ambiguous requests | `pendiente` | [abrir](https://portswigger.net/web-security/host-header/exploiting/lab-host-header-web-cache-poisoning-via-ambiguous-requests) |
| 4 | `host-header-04` | PRACTITIONER | [ ] Routing-based SSRF | `pendiente` | [abrir](https://portswigger.net/web-security/host-header/exploiting/lab-host-header-routing-based-ssrf) |
| 5 | `host-header-05` | PRACTITIONER | [ ] SSRF via flawed request parsing | `pendiente` | [abrir](https://portswigger.net/web-security/host-header/exploiting/lab-host-header-ssrf-via-flawed-request-parsing) |
| 6 | `host-header-06` | PRACTITIONER | [ ] Host validation bypass via connection state attack | `pendiente` | [abrir](https://portswigger.net/web-security/host-header/exploiting/lab-host-header-host-validation-bypass-via-connection-state-attack) |
| 7 | `host-header-07` | EXPERT | [ ] Password reset poisoning via dangling markup | `pendiente` | [abrir](https://portswigger.net/web-security/host-header/exploiting/password-reset-poisoning/lab-host-header-password-reset-poisoning-via-dangling-markup) |

## OAuth authentication (`oauth`) - 6 labs [0/6 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `oauth-01` | APPRENTICE | [ ] Authentication bypass via OAuth implicit flow | `pendiente` | [abrir](https://portswigger.net/web-security/oauth/lab-oauth-authentication-bypass-via-oauth-implicit-flow) |
| 2 | `oauth-02` | PRACTITIONER | [ ] SSRF via OpenID dynamic client registration | `pendiente` | [abrir](https://portswigger.net/web-security/oauth/openid/lab-oauth-ssrf-via-openid-dynamic-client-registration) |
| 3 | `oauth-03` | PRACTITIONER | [ ] Forced OAuth profile linking | `pendiente` | [abrir](https://portswigger.net/web-security/oauth/lab-oauth-forced-oauth-profile-linking) |
| 4 | `oauth-04` | PRACTITIONER | [ ] OAuth account hijacking via redirect_uri | `pendiente` | [abrir](https://portswigger.net/web-security/oauth/lab-oauth-account-hijacking-via-redirect-uri) |
| 5 | `oauth-05` | PRACTITIONER | [ ] Stealing OAuth access tokens via an open redirect | `pendiente` | [abrir](https://portswigger.net/web-security/oauth/lab-oauth-stealing-oauth-access-tokens-via-an-open-redirect) |
| 6 | `oauth-06` | EXPERT | [ ] Stealing OAuth access tokens via a proxy page | `pendiente` | [abrir](https://portswigger.net/web-security/oauth/lab-oauth-stealing-oauth-access-tokens-via-a-proxy-page) |

## File upload vulnerabilities (`file-upload`) - 7 labs [0/7 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `file-upload-01` | APPRENTICE | [ ] Remote code execution via web shell upload | `pendiente` | [abrir](https://portswigger.net/web-security/file-upload/lab-file-upload-remote-code-execution-via-web-shell-upload) |
| 2 | `file-upload-02` | APPRENTICE | [ ] Web shell upload via Content-Type restriction bypass | `pendiente` | [abrir](https://portswigger.net/web-security/file-upload/lab-file-upload-web-shell-upload-via-content-type-restriction-bypass) |
| 3 | `file-upload-03` | PRACTITIONER | [ ] Web shell upload via path traversal | `pendiente` | [abrir](https://portswigger.net/web-security/file-upload/lab-file-upload-web-shell-upload-via-path-traversal) |
| 4 | `file-upload-04` | PRACTITIONER | [ ] Web shell upload via extension blacklist bypass | `pendiente` | [abrir](https://portswigger.net/web-security/file-upload/lab-file-upload-web-shell-upload-via-extension-blacklist-bypass) |
| 5 | `file-upload-05` | PRACTITIONER | [ ] Web shell upload via obfuscated file extension | `pendiente` | [abrir](https://portswigger.net/web-security/file-upload/lab-file-upload-web-shell-upload-via-obfuscated-file-extension) |
| 6 | `file-upload-06` | PRACTITIONER | [ ] Remote code execution via polyglot web shell upload | `pendiente` | [abrir](https://portswigger.net/web-security/file-upload/lab-file-upload-remote-code-execution-via-polyglot-web-shell-upload) |
| 7 | `file-upload-07` | EXPERT | [ ] Web shell upload via race condition | `pendiente` | [abrir](https://portswigger.net/web-security/file-upload/lab-file-upload-web-shell-upload-via-race-condition) |

## JWT (`jwt`) - 8 labs [0/8 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `jwt-01` | APPRENTICE | [ ] JWT authentication bypass via unverified signature | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-unverified-signature) |
| 2 | `jwt-02` | APPRENTICE | [ ] JWT authentication bypass via flawed signature verification | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-flawed-signature-verification) |
| 3 | `jwt-03` | PRACTITIONER | [ ] JWT authentication bypass via weak signing key | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-weak-signing-key) |
| 4 | `jwt-04` | PRACTITIONER | [ ] JWT authentication bypass via jwk header injection | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-jwk-header-injection) |
| 5 | `jwt-05` | PRACTITIONER | [ ] JWT authentication bypass via jku header injection | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-jku-header-injection) |
| 6 | `jwt-06` | PRACTITIONER | [ ] JWT authentication bypass via kid header path traversal | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/lab-jwt-authentication-bypass-via-kid-header-path-traversal) |
| 7 | `jwt-07` | EXPERT | [ ] JWT authentication bypass via algorithm confusion | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/algorithm-confusion/lab-jwt-authentication-bypass-via-algorithm-confusion) |
| 8 | `jwt-08` | EXPERT | [ ] JWT authentication bypass via algorithm confusion with no exposed key | `pendiente` | [abrir](https://portswigger.net/web-security/jwt/algorithm-confusion/lab-jwt-authentication-bypass-via-algorithm-confusion-with-no-exposed-key) |

## Essential skills (`essential-skills`) - 2 labs [0/2 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `essential-skills-01` | PRACTITIONER | [ ] Discovering vulnerabilities quickly with targeted scanning | `pendiente` | [abrir](https://portswigger.net/web-security/essential-skills/using-burp-scanner-during-manual-testing/lab-discovering-vulnerabilities-quickly-with-targeted-scanning) |
| 2 | `essential-skills-02` | PRACTITIONER | [ ] Scanning non-standard data structures | `pendiente` | [abrir](https://portswigger.net/web-security/essential-skills/using-burp-scanner-during-manual-testing/lab-scanning-non-standard-data-structures) |

## Prototype pollution (`prototype-pollution`) - 10 labs [0/10 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `prototype-pollution-01` | PRACTITIONER | [ ] Client-side prototype pollution via browser APIs | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/client-side/browser-apis/lab-prototype-pollution-client-side-prototype-pollution-via-browser-apis) |
| 2 | `prototype-pollution-02` | PRACTITIONER | [ ] DOM XSS via client-side prototype pollution | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/client-side/lab-prototype-pollution-dom-xss-via-client-side-prototype-pollution) |
| 3 | `prototype-pollution-03` | PRACTITIONER | [ ] DOM XSS via an alternative prototype pollution vector | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/client-side/lab-prototype-pollution-dom-xss-via-an-alternative-prototype-pollution-vector) |
| 4 | `prototype-pollution-04` | PRACTITIONER | [ ] Client-side prototype pollution via flawed sanitization | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/client-side/lab-prototype-pollution-client-side-prototype-pollution-via-flawed-sanitization) |
| 5 | `prototype-pollution-05` | PRACTITIONER | [ ] Client-side prototype pollution in third-party libraries | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/client-side/lab-prototype-pollution-client-side-prototype-pollution-in-third-party-libraries) |
| 6 | `prototype-pollution-06` | PRACTITIONER | [ ] Privilege escalation via server-side prototype pollution | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/server-side/lab-privilege-escalation-via-server-side-prototype-pollution) |
| 7 | `prototype-pollution-07` | PRACTITIONER | [ ] Detecting server-side prototype pollution without polluted property reflection | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/server-side/lab-detecting-server-side-prototype-pollution-without-polluted-property-reflection) |
| 8 | `prototype-pollution-08` | PRACTITIONER | [ ] Bypassing flawed input filters for server-side prototype pollution | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/server-side/lab-bypassing-flawed-input-filters-for-server-side-prototype-pollution) |
| 9 | `prototype-pollution-09` | PRACTITIONER | [ ] Remote code execution via server-side prototype pollution | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/server-side/lab-remote-code-execution-via-server-side-prototype-pollution) |
| 10 | `prototype-pollution-10` | EXPERT | [ ] Exfiltrating sensitive data via server-side prototype pollution | `pendiente` | [abrir](https://portswigger.net/web-security/prototype-pollution/server-side/lab-exfiltrating-sensitive-data-via-server-side-prototype-pollution) |

## GraphQL API vulnerabilities (`graphql`) - 5 labs [0/5 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `graphql-01` | APPRENTICE | [ ] Accessing private GraphQL posts | `pendiente` | [abrir](https://portswigger.net/web-security/graphql/lab-graphql-reading-private-posts) |
| 2 | `graphql-02` | PRACTITIONER | [ ] Accidental exposure of private GraphQL fields | `pendiente` | [abrir](https://portswigger.net/web-security/graphql/lab-graphql-accidental-field-exposure) |
| 3 | `graphql-03` | PRACTITIONER | [ ] Finding a hidden GraphQL endpoint | `pendiente` | [abrir](https://portswigger.net/web-security/graphql/lab-graphql-find-the-endpoint) |
| 4 | `graphql-04` | PRACTITIONER | [ ] Bypassing GraphQL brute force protections | `pendiente` | [abrir](https://portswigger.net/web-security/graphql/lab-graphql-brute-force-protection-bypass) |
| 5 | `graphql-05` | PRACTITIONER | [ ] Performing CSRF exploits over GraphQL | `pendiente` | [abrir](https://portswigger.net/web-security/graphql/lab-graphql-csrf-via-graphql-api) |

## Race conditions (`race-conditions`) - 6 labs [0/6 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `race-conditions-01` | APPRENTICE | [ ] Limit overrun race conditions | `pendiente` | [abrir](https://portswigger.net/web-security/race-conditions/lab-race-conditions-limit-overrun) |
| 2 | `race-conditions-02` | PRACTITIONER | [ ] Bypassing rate limits via race conditions | `pendiente` | [abrir](https://portswigger.net/web-security/race-conditions/lab-race-conditions-bypassing-rate-limits) |
| 3 | `race-conditions-03` | PRACTITIONER | [ ] Multi-endpoint race conditions | `pendiente` | [abrir](https://portswigger.net/web-security/race-conditions/lab-race-conditions-multi-endpoint) |
| 4 | `race-conditions-04` | PRACTITIONER | [ ] Single-endpoint race conditions | `pendiente` | [abrir](https://portswigger.net/web-security/race-conditions/lab-race-conditions-single-endpoint) |
| 5 | `race-conditions-05` | PRACTITIONER | [ ] Exploiting time-sensitive vulnerabilities | `pendiente` | [abrir](https://portswigger.net/web-security/race-conditions/lab-race-conditions-exploiting-time-sensitive-vulnerabilities) |
| 6 | `race-conditions-06` | EXPERT | [ ] Partial construction race conditions | `pendiente` | [abrir](https://portswigger.net/web-security/race-conditions/lab-race-conditions-partial-construction) |

## NoSQL injection (`nosql`) - 4 labs [0/4 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `nosql-01` | APPRENTICE | [ ] Detecting NoSQL injection | `pendiente` | [abrir](https://portswigger.net/web-security/nosql-injection/lab-nosql-injection-detection) |
| 2 | `nosql-02` | APPRENTICE | [ ] Exploiting NoSQL operator injection to bypass authentication | `pendiente` | [abrir](https://portswigger.net/web-security/nosql-injection/lab-nosql-injection-bypass-authentication) |
| 3 | `nosql-03` | PRACTITIONER | [ ] Exploiting NoSQL injection to extract data | `pendiente` | [abrir](https://portswigger.net/web-security/nosql-injection/lab-nosql-injection-extract-data) |
| 4 | `nosql-04` | PRACTITIONER | [ ] Exploiting NoSQL operator injection to extract unknown fields | `pendiente` | [abrir](https://portswigger.net/web-security/nosql-injection/lab-nosql-injection-extract-unknown-fields) |

## API testing (`api-testing`) - 5 labs [0/5 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `api-testing-01` | APPRENTICE | [ ] Exploiting an API endpoint using documentation | `pendiente` | [abrir](https://portswigger.net/web-security/api-testing/lab-exploiting-api-endpoint-using-documentation) |
| 2 | `api-testing-02` | PRACTITIONER | [ ] Exploiting server-side parameter pollution in a query string | `pendiente` | [abrir](https://portswigger.net/web-security/api-testing/server-side-parameter-pollution/lab-exploiting-server-side-parameter-pollution-in-query-string) |
| 3 | `api-testing-03` | PRACTITIONER | [ ] Finding and exploiting an unused API endpoint | `pendiente` | [abrir](https://portswigger.net/web-security/api-testing/lab-exploiting-unused-api-endpoint) |
| 4 | `api-testing-04` | PRACTITIONER | [ ] Exploiting a mass assignment vulnerability | `pendiente` | [abrir](https://portswigger.net/web-security/api-testing/lab-exploiting-mass-assignment-vulnerability) |
| 5 | `api-testing-05` | EXPERT | [ ] Exploiting server-side parameter pollution in a REST URL | `pendiente` | [abrir](https://portswigger.net/web-security/api-testing/server-side-parameter-pollution/lab-exploiting-server-side-parameter-pollution-in-rest-url) |

## Web LLM attacks (`llm-attacks`) - 8 labs [0/8 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `llm-attacks-01` | APPRENTICE | [ ] Exploiting LLM APIs with excessive agency | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/lab-exploiting-llm-apis-with-excessive-agency) |
| 2 | `llm-attacks-02` | PRACTITIONER | [ ] Exploiting vulnerabilities in LLM APIs | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/lab-exploiting-vulnerabilities-in-llm-apis) |
| 3 | `llm-attacks-03` | PRACTITIONER | [ ] Indirect prompt injection | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/lab-indirect-prompt-injection) |
| 4 | `llm-attacks-04` | EXPERT | [ ] Exploiting insecure output handling in LLMs | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/lab-exploiting-insecure-output-handling-in-llms) |
| 5 | `llm-attacks-05` | APPRENTICE | [ ] Exploiting AI agents to perform destructive actions | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/ai-powered-scanner-vulnerabilities/lab-indirect-prompt-injection-via-ai-powered-scan) |
| 6 | `llm-attacks-06` | APPRENTICE | [ ] Exploiting AI agents to exfiltrate sensitive information | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/ai-powered-scanner-vulnerabilities/lab-sensitive-information-exfiltration) |
| 7 | `llm-attacks-07` | PRACTITIONER | [ ] Exploiting AI agents to trigger secondary vulnerabilities | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/ai-powered-scanner-vulnerabilities/lab-exploiting-target-website-vulnerabilities-to-bypass-restrictions) |
| 8 | `llm-attacks-08` | PRACTITIONER | [ ] Bypassing AI scanner defenses to exfiltrate sensitive information | `pendiente` | [abrir](https://portswigger.net/web-security/llm-attacks/ai-powered-scanner-vulnerabilities/lab-bypassing-ai-scanner-defenses-to-exfiltrate-sensitive-information) |

## Web cache deception (`web-cache-deception`) - 5 labs [0/5 hechos]

| # | ID | Nivel | Lab | Estado | Link |
|---:|---|---|---|---|---|
| 1 | `web-cache-deception-01` | APPRENTICE | [ ] Exploiting path mapping for web cache deception | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-deception/lab-wcd-exploiting-path-mapping) |
| 2 | `web-cache-deception-02` | PRACTITIONER | [ ] Exploiting path delimiters for web cache deception | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-deception/lab-wcd-exploiting-path-delimiters) |
| 3 | `web-cache-deception-03` | PRACTITIONER | [ ] Exploiting origin server normalization for web cache deception | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-deception/lab-wcd-exploiting-origin-server-normalization) |
| 4 | `web-cache-deception-04` | PRACTITIONER | [ ] Exploiting cache server normalization for web cache deception | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-deception/lab-wcd-exploiting-cache-server-normalization) |
| 5 | `web-cache-deception-05` | EXPERT | [ ] Exploiting exact-match cache rules for web cache deception | `pendiente` | [abrir](https://portswigger.net/web-security/web-cache-deception/lab-wcd-exploiting-exact-match-cache-rules) |

---

Generado por `generate_tracker.py`. Estado persistido en `labs.json`.
