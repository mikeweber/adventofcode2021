# Day 1

## Part A
I've never really even looked at Go before. It was surprisingly easy
to pick up. I've only scratched the surface (learning the type syntax,
figuring out how arrays/slices work, reading and parsing a file), but
I learned enough to solve the first problem with relative ease. I was
also happy to learn that tests are built in and not too difficult to
write. Just writing tests for the most basic cases was enough to help
me focus and write some simple, straightforward code.

I looped through the array, starting at the second element, and peeking
back at the previous element, to determine if the numbers were increasing
or not. Then returned the number of times there was an increase.

## Big O notation
O(n)

## What did I learn?
The basic syntax and structure of a Go program. It was pretty painless.

## Part B
I used the exact same approach as part A, but instead of starting at the
second element and looking back one, I started at the 4th element, summed
the previous window, then summed the current window, and increased the
count whenever the current window was larger. I likely could have created
a quick sum function that took in a slice of an array, but I felt lazy and
just hard-coded the index offsets.

## Big O notation
O(n)

## What did I learn?
I learned how to read command line arguments, so that I could have a single
`runner` program that can run the specified day and part. I'm guessing
within a day or two, I'll create a sort of helper directory to keep track
of common functions, like reading and parsing files.

