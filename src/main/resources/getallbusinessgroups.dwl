%dw 2.0
output application/java
---
        payload.subOrganizations map {
                name: $.name,
                id: $.id,
                owner_name: $.ownerName,
                vCoresProduction: $.entitlements.vCoresProduction.assigned,
                vCoresSandbox: $.entitlements.vCoresSandbox.assigned,
                vCoresDesign: $.entitlements.vCoresDesign.assigned,
                staticIps: $.staticIps.assigned,
                created_at: $.createdAt,
                updated_at: $.updatedAt
        } ++ [{
        name: payload.name,
        id: payload.id,
        owner_name: payload.ownerName,
        vCoresProduction: payload.vCoresProduction.assigned,
        vCoresSandbox: payload.vCoresSandbox.assigned,
        vCoresDesign: payload.vCoresDesign.assigned,
        staticIps: payload.staticIps.assigned,
        created_at: payload.createdAt,
        updated_at: payload.updatedAt
        }]

