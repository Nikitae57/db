import java.io.*
import java.util.*
import kotlin.collections.ArrayList

class Main {

    private lateinit var db: File
    private val MENU = """
        |1) Show all students
        |2) Find student
        |3) Add student
        |4) Modify student
        |5) Delete student
    """.trimMargin()

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            Main().showMenu()
        }
    }

    fun showMenu() {
        val scanner = Scanner(System.`in`)
        val dbFileName = scanner.ask("Enter db file name")
        db = File(dbFileName)
        val block = readBlocks(db)

        while (true) {
            when (scanner.nextLine()) {
                "1" -> showEverything(block)
                else -> println("Wrong")
            }
        }
    }

    fun readBlocks(file: File): Block {
        val objectInputStream = ObjectInputStream(file.inputStream())
        var firstBlock: Block? = null

        try {
            firstBlock = objectInputStream.readObject() as Block?

            var currentBlock = firstBlock
            while (true) {
                val nextBlock = objectInputStream.readObject() as Block
                currentBlock?.nextBlock = nextBlock
                currentBlock = nextBlock
            }
        } catch (eofEx: EOFException) {
            return firstBlock ?: Block()
        }
    }

    fun findLastBlock(block: Block): Block {
        var currentBlock = block.nextBlock
        while (currentBlock != null) {
            if (currentBlock.nextBlock == null ||
                    currentBlock.nextBlock?.size == 0) {

                return currentBlock
            }

            currentBlock = currentBlock.nextBlock
        }

        return block
    }

    fun select(
        block: Block,
        field: String,
        entry: StudentEntry? = null
    ): ArrayList<StudentEntry> {

        val suitableEntries = ArrayList<StudentEntry>()
        var currentBlock = block
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

        return suitableEntries
    }

    fun add(firstBlock: Block, studentEntry: StudentEntry): Boolean {
        if (select(firstBlock, "", studentEntry).size != 0) {
            return false
        }

        val lastBlock = findLastBlock(firstBlock)

        if (!lastBlock.isFull) {
            lastBlock.add(studentEntry)
        } else {
            val newLastBlock = Block(arrayListOf(studentEntry))
            lastBlock.nextBlock = newLastBlock
        }

        save(firstBlock, db)
        return true
    }

    fun delete(firstBlock: Block, studentEntry: StudentEntry) {
        var lastBlock = findLastBlock(firstBlock)

        var currentBlock: Block? = firstBlock
        while (currentBlock != null) {

            var size = currentBlock.size
            var i = 0
            while (i < size) {
                if (currentBlock.entries[i] != studentEntry) {
                    i++
                    continue
                }

                if (lastBlock.size == 0) {
                    lastBlock = findLastBlock(firstBlock)
                }

                currentBlock.entries[i] = lastBlock.last
                lastBlock.removeLast()
                size--
                i++
            }

            currentBlock = currentBlock.nextBlock
        }
        save(firstBlock, db)
    }

    fun save(firstBlock: Block, db: File) {
        db.delete()
        db.createNewFile()

        val objectOutputStream = ObjectOutputStream(db.outputStream())
        objectOutputStream.writeObject(firstBlock)
        objectOutputStream.close()
    }

    fun modify(block: Block, entry: StudentEntry) {
        println("What do you want to change?")
        println("1) Student id")
        println("2) Group id")
        println("3) Last name")
        println("4) First name")
        println("5) Middle name")

        try {
            val scanner = Scanner(System.`in`)
            when (scanner.nextInt()) {
                1 -> modifyStudId(entry, block)
                2 -> modifyGroupId(entry, block)
                3 -> modifyLastname(entry, block)
                4 -> modifyFirstName(entry, block)
                5 -> modifyMiddleName(entry, block)

                else -> throw IOException()
            }
        } catch (ioex: IOException) {
            println("Incorrect choice")
        }
    }

    private fun modifyMiddleName(entry: StudentEntry, block: Block) {
        println("Enter name:")
        entry.midName = Scanner(System.`in`).nextLine()
        save(block, db)
    }

    private fun modifyFirstName(entry: StudentEntry, block: Block) {
        println("Enter name:")
        entry.firstName = Scanner(System.`in`).nextLine()
        save(block, db)
    }

    private fun modifyLastname(entry: StudentEntry, block: Block) {
        println("Enter name:")
        entry.lastName = Scanner(System.`in`).nextLine()
        save(block, db)
    }

    private fun modifyGroupId(entry: StudentEntry, block: Block) {
        println("Enter group id:")
        entry.groupId = Scanner(System.`in`).nextInt()
        save(block, db)
    }

    fun modifyStudId(entry: StudentEntry, block: Block) {
        println("Enter student id:")
        val id = Scanner(System.`in`).nextInt()

        if (idIsUnique(id, block)) {
            entry.studId = id
            save(block, db)
        }
    }

    fun idIsUnique(id: Int, block: Block): Boolean {
        var currentBlock = block

        while (true) {
            val idAlreadyExists = currentBlock.entries.any { it.studId == id }
            if (idAlreadyExists) {
                return false
            }

            currentBlock = currentBlock.nextBlock ?: break
        }

        return true
    }

    fun showEverything(block: Block) {
        var currentBlock = block
        while (true) {
            currentBlock.print()
            currentBlock = currentBlock.nextBlock ?: break
        }
    }
}