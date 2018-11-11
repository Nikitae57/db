package util

import java.util.*

fun Scanner.ask(prompt: String): String {
    println(prompt)
    return nextLine()
}