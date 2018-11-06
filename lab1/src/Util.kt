import java.io.File
import java.util.*

class Util {
    companion object {
        fun generateBlock(): Block {
            val f = File("db2")
            val scanner = Scanner(f.inputStream())

            val firstBlock = Block()
            var currentBlock = firstBlock
            while (scanner.hasNext()) {
                val sId = scanner.nextInt()
                val gId = scanner.nextInt()
                val name = scanner.nextLine().trim().split(' ')
                val entry = StudentEntry(
                    sId,
                    gId,
                    name[0],
                    name[1],
                    name[2]
                )

                if (!currentBlock.add(entry)) {
                    val nextBlock = Block(arrayListOf(entry))
                    currentBlock.nextBlock = nextBlock
                    currentBlock = nextBlock
                }
            }

            return firstBlock
        }
    }
}