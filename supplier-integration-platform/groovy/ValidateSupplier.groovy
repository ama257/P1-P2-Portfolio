import com.sap.gateway.ip.core.customdev.util.Message
import groovy.json.JsonSlurper

def Message processData(Message message) {

    String body = message.getBody(String.class)

    if (body == null || body.trim().isEmpty()) {
        throw new IllegalArgumentException(
            "Supplier validation failed: request body is empty"
        )
    }

    def supplier

    try {
        supplier = new JsonSlurper().parseText(body)
    } catch (Exception e) {
        throw new IllegalArgumentException(
            "Supplier validation failed: request body must be valid JSON"
        )
    }

    if (!(supplier instanceof Map)) {
        throw new IllegalArgumentException(
            "Supplier validation failed: JSON must be an object"
        )
    }

    def requiredFields = [
        "name",
        "email",
        "phone",
        "country"
    ]

    def missingFields = requiredFields.findAll { field ->
        supplier[field] == null ||
        supplier[field].toString().trim().isEmpty()
    }

    if (!missingFields.isEmpty()) {
        throw new IllegalArgumentException(
            "Supplier validation failed: missing required fields: " +
            missingFields.join(", ")
        )
    }

    String email = supplier.email.toString().trim()
    def emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

    if (!(email ==~ emailPattern)) {
        throw new IllegalArgumentException(
            "Supplier validation failed: invalid email format"
        )
    }

    message.setBody(body)
    return message
}
