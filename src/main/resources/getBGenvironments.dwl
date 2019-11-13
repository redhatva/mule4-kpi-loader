%dw 2.0
output application/json
---
payload.data map {
        name: $.name,
        id: $.id

}
