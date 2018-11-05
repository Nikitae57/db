import java.io.*
import java.util.*
import kotlin.collections.ArrayList

class Main {

    private lateinit var db: File

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            Main().go()
        }
    }

    fun go() {
        db = File("db")
        val block = readBlocks(db)
        block.print()

        val entry = select(block, "11")[0]
        println(add(block, entry))
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
        TODO("not implemented")
    }

    private fun modifyFirstName(entry: StudentEntry) {
        TODO("not implemented")
    }

    private fun modifyLastname(entry: StudentEntry) {
        TODO("not implemented")
    }

    private fun modifyGroupId(entry: StudentEntry) {
        TODO("not implemented")
    }

    fun modifyStudId(entry: StudentEntry) {
        TODO("not implemented")
    }
}