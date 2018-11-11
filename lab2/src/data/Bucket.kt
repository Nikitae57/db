package data

import java.io.Serializable

class Bucket(val blocks: ArrayList<Block> = ArrayList()) : Serializable {
    val firstBlock: Block?
        get() {
            if (blocks.size == 0) { return null }

            return blocks[0]
        }

    val lastBlock: Block?
        get() {
            if (blocks.size == 0) { return null }

            var currentBlock = firstBlock
            while (currentBlock != null) {
                if (currentBlock.nextBlock == null ||
                    currentBlock.nextBlock?.size == 0) {

                    return currentBlock
                }

                currentBlock = currentBlock.nextBlock
            }

            return null
        }
}