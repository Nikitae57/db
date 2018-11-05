import java.io.Serializable

data class StudentEntry(
    val studId: Int,
    val groupId: Int,
    val lastName: String,
    val firstName: String,
    val midName: String
) : Serializable