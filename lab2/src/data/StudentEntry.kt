package data

import java.io.Serializable

data class StudentEntry(
    var studId: Int,
    var groupId: Int,
    var lastName: String,
    var firstName: String,
    var midName: String
) : Serializable