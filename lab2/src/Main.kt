import data.Block
import data.Bucket
import data.StudentEntry
import util.ask
import java.io.*
import java.util.*
import kotlin.collections.ArrayList

fun main(args: Array<String>) {
    Main().showMenu()
}

class Main {

    private lateinit var db: File
    private lateinit var scanner: Scanner
    private lateinit var buckets: ArrayList<Bucket>

    private val MENU = """
        |========================
        || 1) Show all students |
        || 2) Find student      |
        || 3) Add student       |
        || 4) Modify student    |
        || 5) Delete student    |
        |========================
    """.trimMargin()

    fun showMenu() {
        scanner = Scanner(System.`in`)
        val dbFileName = scanner.ask("Enter db file name")
        db = File(dbFileName)
        buckets = openDb(db)

        while (true) {
            println("\n$MENU\n")
            when (scanner.nextLine()) {
                "1" -> showEverything()
                "2" -> menuSelect()
                "3" -> menuAddStudent()
                "4" -> menuModify()
                "5" -> menuDelete()

                else -> println("Wrong")
            }
        }
    }

    fun menuDelete() {
        val students = menuSelect()
        val studentIndex = scanner.ask("Which one?").toInt()
        val studentToDelete = students[studentIndex]

        delete(studentToDelete)
    }

    fun menuModify() {
        val students = menuSelect()
        if (students.size == 0) {
            println("Not found")
            return
        }

        val studentIndex = scanner.ask("Which one?").toInt()
        val entry = students[studentIndex]

        modify(entry)
    }

    fun menuAddStudent() {
        val sId = scanner.ask("Student id:").toInt()
        val bucket = buckets[sId % 4]

        if (!idIsUnique(sId, bucket)) {
            println("Already exists")
            return
        }

        val gId = scanner.ask("Group id:").toInt()
        val lName = scanner.ask("Last name:")
        val fName = scanner.ask("First name:")
        val mName = scanner.ask("Middle name:")

        val studentEntry = StudentEntry(sId, gId, lName, fName, mName)
        add(studentEntry)
    }

    fun menuSelect(): ArrayList<StudentEntry> {
        val field = scanner.ask("Enter something to search:")
        val students = select(field)
        listSelectedStudents(students)

        return students
    }

    fun select(
        field: String,
        entry: StudentEntry? = null
    ): ArrayList<StudentEntry> {

        val suitableEntries = ArrayList<StudentEntry>()
        for (i in 0 until 4) {
            var currentBlock = buckets[i].firstBlock ?: continue

            while (true) {
                suitableEntries.addAll(
                    currentBlock.entries.filter {
                        it.studId.toString() == field
                                || it.groupId.toString() == field
                                || it.firstName == field
                                || it.lastName == field
                                || it.midName == field
                                || it == entry
                    }
                )

                currentBlock = currentBlock.nextBlock ?: break
            }
        }

        return suitableEntries
    }

    fun add(studentEntry: StudentEntry): Boolean {
        val bucket = buckets[studentEntry.studId % 4]
        var lastBlock = bucket.lastBlock

        if (lastBlock == null) {
            val block = Block()
            bucket.blocks.add(block)
            lastBlock = block
        }

        if (!lastBlock.isFull) {
            lastBlock.add(studentEntry)
        } else {
            val newLastBlock = Block(arrayListOf(studentEntry))
            lastBlock.nextBlock = newLastBlock
        }

        save(db)
        return true
    }

    fun delete(studentEntry: StudentEntry) {
        val bucket = buckets[studentEntry.studId % 4]
        var lastBlock = bucket.lastBlock ?: return

        var currentBlock: Block? = bucket.firstBlock
        while (currentBlock != null) {

            var size = currentBlock.size
            var i = 0
            while (i < size) {
                if (currentBlock.entries[i] != studentEntry) {
                    i++
                    continue
                }

                if (lastBlock.size == 0) {
                    lastBlock = bucket.lastBlock ?: return
                }

                currentBlock.entries[i] = lastBlock.last
                lastBlock.removeLast()
                size--
                i++
            }

            currentBlock = currentBlock.nextBlock
        }
        save(db)
    }

    fun save(db: File) {
        db.delete()
        db.createNewFile()

        val objectOutputStream = ObjectOutputStream(db.outputStream())
        objectOutputStream.writeObject(buckets)
        objectOutputStream.close()
    }

    fun modify(entry: StudentEntry) {
        println("What do you want to change?")
        println("1) Student id")
        println("2) Group id")
        println("3) Last name")
        println("4) First name")
        println("5) Middle name")

        try {
            val scanner = Scanner(System.`in`)
            when (scanner.nextInt()) {
                1 -> modifyStudId(entry)
                2 -> modifyGroupId(entry)
                3 -> modifyLastname(entry)
                4 -> modifyFirstName(entry)
                5 -> modifyMiddleName(entry)

                else -> throw IOException()
            }
        } catch (ioex: IOException) {
            println("Incorrect choice")
        }
    }

    private fun modifyMiddleName(entry: StudentEntry) {
        println("Enter name:")
        entry.midName = Scanner(System.`in`).nextLine()
        save(db)
        println("Name changed")
    }

    private fun modifyFirstName(entry: StudentEntry) {
        println("Enter name:")
        entry.firstName = Scanner(System.`in`).nextLine()
        save(db)
        println("Name changed")
    }

    private fun modifyLastname(entry: StudentEntry) {
        println("Enter name:")
        entry.lastName = Scanner(System.`in`).nextLine()
        save(db)
        println("Name changed")
    }

    private fun modifyGroupId(entry: StudentEntry) {
        println("Enter group id:")
        entry.groupId = Scanner(System.`in`).nextInt()
        save(db)
        println("Id changed")
    }

    fun modifyStudId(entry: StudentEntry) {
        println("Enter student id:")
        val id = Scanner(System.`in`).nextInt()
        val bucket = buckets[id % 4]

        if (idIsUnique(id, bucket)) {
            entry.studId = id
            save(db)
            println("Id changed")
        } else {
            println("Not unique")
        }
    }

    fun idIsUnique(id: Int, bucket: Bucket): Boolean {
        var currentBlock = bucket.firstBlock ?: return true

        while (true) {
            val idAlreadyExists = currentBlock.entries.any { it.studId == id }
            if (idAlreadyExists) {
                return false
            }

            currentBlock = currentBlock.nextBlock ?: break
        }

        return true
    }

    fun showEverything() {
        for (i in 0 until 4) {
            var currentBlock = buckets[i].firstBlock ?: continue

            while (true) {
                currentBlock.print()
                currentBlock = currentBlock.nextBlock ?: break
            }
        }
    }

    fun openDb(file: File): ArrayList<Bucket> {
        return try {
            ObjectInputStream(file.inputStream())
                .readObject() as ArrayList<Bucket>
        } catch (eofEx: EOFException) {
            arrayListOf(
                Bucket(),
                Bucket(),
                Bucket(),
                Bucket()
            )
        }
    }

    fun listSelectedStudents(students: ArrayList<StudentEntry>) {
        var id = 0
        println("========================")
        students.forEach {
            println("${id++}) ${it.studId} ${it.groupId} ${it.lastName} " +
                    "${it.firstName} ${it.midName}")
        }
        println("========================")
    }
}