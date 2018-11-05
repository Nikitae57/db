import java.io.Serializable

class Block(val entries: ArrayList<StudentEntry> = ArrayList()) : Serializable {

    var nextBlock: Block? = null
    val size: Int
        get() = entries.size

    val isFull: Boolean
        get() = entries.size >= 5

    val last: StudentEntry
        get() = entries.last()

    fun add(studentEntry: StudentEntry): Boolean {
        if (entries.size >= 5) { return false }

        entries.add(studentEntry)
        return true
    }

    fun removeLast(): Boolean {
        if (size > 0) {
            entries.removeAt(entries.lastIndex)
            return true
        }

        return false
    }

    fun print() {
        println()
        entries.forEach {
            println("${it.studId} ${it.groupId} ${it.lastName} " +
                    "${it.firstName} ${it.midName}")
        }
    }
}