#  Fall 2026
#  Team Members:
#  % Effort    :
#
# ECE369A,
#

########################################################################################################################
### data
########################################################################################################################
.data
# test input
# asize : dimensions of the frame [i, j] and window [k, l]
#         i: number of rows,  j: number of cols
#         k: number of rows,  l: number of cols
# frame : frame data with i*j number of pixel values
# window: search window with k*l number of pixel values
#
# $v0 is for row / $v1 is for column


# test 1 For the 16X16 frame size and a 8X4 window size
# The result should be 3, 2
asize1:  .word    16, 16, 8, 4    #i, j, k, l
frame1:  .word    7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
         .word    7, 8, 8, 8, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
         .word    7, 8, 8, 8, 2, 8, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30,
         .word    7, 8, 8, 8, 8, 8, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45,
         .word    0, 4, 8, 8, 8, 8, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60,
         .word    0, 5, 8, 8, 8, 8, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75,
         .word    0, 6, 8, 8, 8, 8, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90,
         .word    0, 4, 8, 8, 8, 8, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105,
         .word    0, 1, 8, 8, 8, 8, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120,
         .word    0, 1, 8, 8, 8, 8, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135,
         .word    0, 10, 8, 8, 8, 8, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150,
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165,
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4,
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5,
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6
window1: .word    8, 8, 8, 8,
         .word    8, 8, 8, 8,
         .word    8, 8, 8, 8,
         .word    8, 8, 8, 8,
         .word    8, 8, 8, 8,
         .word    8, 8, 8, 8,
         .word    8, 8, 8, 8,
         .word    8, 8, 8, 8


# test 2 For the 32X32 frame and a 8X16 window size
# The result should be 16, 0
asize2:  .word    32, 32, 8, 16    #i, j, k, l
frame2:  .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8,
         .word    1, 1, 1, 1, 1, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8

window2: .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,


# test 3 For the 16X16 frame and a 4X8 window size
# The result should be 12, 0
asize3:  .word    16, 16, 4, 8    #i, j, k, l
frame3:  .word    9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 7, 7,
         .word    9, 7, 7, 7, 7, 5, 6, 7, 8, 9, 10, 11, 6, 7, 7, 7,
         .word    9, 7, 7, 7, 7, 3, 12, 14, 16, 18, 20, 6, 6, 7, 7, 7,
         .word    9, 7, 7, 7, 7, 4, 18, 21, 24, 27, 30, 33, 6, 7, 7, 7,
         .word    0, 7, 7, 7, 7, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60,
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75,
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90,
         .word    0, 4, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105,
         .word    0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120,
         .word    0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135,
         .word    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150,
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165,
         .word    9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3

window3: .word    9, 9, 9, 9, 9, 9, 9, 9,
         .word    9, 9, 9, 9, 9, 9, 9, 9,
         .word    9, 9, 9, 9, 9, 9, 9, 9,
         .word    9, 9, 9, 9, 9, 9, 9, 9



# test 4 For the 16X16 frame and a 8X8 window size
# The result should be 8, 3
asize4: .word    16, 16, 8, 8    #i, j, k, l
frame4: .word    9, 19, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 91, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 9, 19, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 9, 91, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    91, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 19, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    9, 91, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0, 1, 2, 3,
         .word    1, 2, 3, 9, 9, 19, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0,
         .word    1, 2, 3, 9, 9, 9, 9, 9, 9, 9, 9, 96, 108, 120, 132, 0

window4:   .word    9, 9, 9, 9, 9, 9, 9, 9,
            .word    9, 9, 9, 9, 9, 9, 9, 9,
            .word    9, 9, 9, 9, 9, 9, 9, 9,
            .word    9, 9, 9, 9, 9, 9, 9, 9,
            .word    9, 9, 9, 9, 9, 9, 9, 9,
            .word    9, 9, 9, 9, 9, 9, 9, 9,
            .word    9, 9, 9, 9, 9, 9, 9, 9,
            .word    9, 9, 9, 9, 9, 9, 9, 9


# test 5 For the 32X32 frame and a 4X4 window size
# The result should be 5, 16 since its the first of multiple repeating occurences
asize5: .word    32, 32, 4, 4    #i, j, k, l
frame5: .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
         .word    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1

window5:   .word    10, 10, 10, 10,
            .word    10, 10, 10, 10,
            .word    10, 10, 10, 10,
            .word    10, 10, 10, 10





newline: .asciiz     "\n"


########################################################################################################################
### main
########################################################################################################################

.text

.globl main

main:
    addi    $sp, $sp, -4    # Make space on stack
    sw      $ra, 0($sp)     # Save return address

    # Start test 1
    ############################################################
    addi    $a0, $zero, 0     # 1st parameter: address of asize1[0]
    addi    $a1, $zero, 16     # 2nd parameter: address of frame1[0]
    addi    $a2, $zero, 1040    # 3rd parameter: address of window1[0]

    jal     vbsme           # call function
 #   jal     print_result    # print results to console

    ############################################################
    # End of test 1


    # Start test 2
    ############################################################
    addi    $a0, $zero, 1168     # 1st parameter: address of asize2[0]
    addi    $a1, $zero, 1184     # 2nd parameter: address of frame2[0]
    addi    $a2, $zero, 5280    # 3rd parameter: address of window2[0]

    jal     vbsme           # call function
 #   jal     print_result    # print results to console
    ############################################################
    # End of test 2


    # Start test 3
    ############################################################
    addi    $a0, $zero, 5792     # 1st parameter: address of asize3[0]
    addi    $a1, $zero, 5808     # 2nd parameter: address of frame3[0]
    addi    $a2, $zero, 6832    # 3rd parameter: address of window3[0]

    jal     vbsme           # call function
 #   jal     print_result    # print results to console
    ############################################################
    # End of test 3


    # Start test 4
    ############################################################
    addi    $a0, $zero, 6960     # 1st parameter: address of asize4[0]
    addi    $a1, $zero, 6976     # 2nd parameter: address of frame4[0]
    addi    $a2, $zero, 8000    # 3rd parameter: address of window4[0]

    jal     vbsme           # call function
 #   jal     print_result    # print results to console
    ############################################################
    # End of test 4


    # Start test 5
    ############################################################
    addi    $a0, $zero, 8256     # 1st parameter: address of asize5[0]
    addi    $a1, $zero, 8272     # 2nd parameter: address of frame5[0]
    addi    $a2, $zero, 12368    # 3rd parameter: address of window5[0]

    jal     vbsme           # call function
 #  jal     print_result    # print results to console
    ############################################################
    # End of test 5

    lw      $ra, 0($sp)         # Restore return address
    addi    $sp, $sp, 4         # Restore stack pointer
    j       end_program                 # Return

end_program:                    # remain in infinite loop
	j end_program
################### Print Result ####################################
#print_result:
    # Printing $v0
 #   add     $a0, $v0, $zero     # Load $v0 for printing
 #   li      $v0, 1              # Load the system call numbers
 #   syscall

    # Print newline.
 #   la      $a0, newline          # Load value for printing
 #   li      $v0, 4                # Load the system call numbers
 #   syscall

    # Printing $v1
 #   add     $a0, $v1, $zero      # Load $v1 for printing
 #   li      $v0, 1                # Load the system call numbers
 #   syscall

    # Print newline.
 #   la      $a0, newline          # Load value for printing
 #   li      $v0, 4                # Load the system call numbers
 #   syscall

    # Print newline.
 #   la      $a0, newline          # Load value for printing
 #   li      $v0, 4                # Load the system call numbers
 #   syscall

 #   jr      $ra                   #function return

#####################################################################
### vbsme
#####################################################################


# vbsme.s
# motion estimation is a routine in h.264 video codec that
# takes about 80% of the execution time of the whole code
# given a frame(2d array, x and y dimensions can be any integer
# between 16 and 64) where "frame data" is stored under "frame"
# and a window (2d array of size 4x4, 4x8, 8x4, 8x8, 8x16, 16x8 or 16x16)
# where "window data" is stored under "window"
# and size of "window" and "frame" arrays are stored under "asize"

# - initially current sum of difference is set to a very large value
# - move "window" over the "frame" one cell at a time starting with location (0,0)
# - moves are based circular pattern
# - for each move, function calculates  the sum of absolute difference (SAD)
#   between the window and the overlapping block on the frame.
# - if the calculated sum of difference is LESS THAN the current sum of difference
#   then the current sum of difference is updated and the coordinate of the top left corner
#   for that matching block in the frame is recorded.

# for example SAD of two 4x4 arrays "window" and "block" shown below is 3
# window         block
# -------       --------
# 1 2 2 3       1 4 2 3
# 0 0 3 2       0 0 3 2
# 0 0 0 0       0 0 0 0
# 1 0 0 5       1 0 0 4

# program keeps track of the window position that results
# with the minimum sum of absolute difference.
# after scannig the whole frame
# program returns the coordinates of the block with the minimum SAD
# in $v0 (row) and $v1 (col)


# Sample Inputs and Output shown below:
# Frame:
#
#  0   1   2   3   0   0   0   0   0   0   0   0   0   0   0   0
#  1   2   3   4   4   5   6   7   8   9  10  11  12  13  14  15
#  2   3  32   1   2   3  12  14  16  18  20  22  24  26  28  30
#  3   4   1   2   3   4  18  21  24  27  30  33  36  39  42  45
#  0   4   2   3   4   5  24  28  32  36  40  44  48  52  56  60
#  0   5   3   4   5   6  30  35  40  45  50  55  60  65  70  75
#  0   6  12  18  24  30  36  42  48  54  60  66  72  78  84  90
#  0   7  14  21  28  35  42  49  56  63  70  77  84  91  98 105
#  0   8  16  24  32  40  48  56  64  72  80  88  96 104 112 120
#  0   9  18  27  36  45  54  63  72  81  90  99 108 117 126 135
#  0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150
#  0  11  22  33  44  55  66  77  88  99 110 121 132 143 154 165
#  0  12  24  36  48  60  72  84  96 108 120 132   0   1   2   3
#  0  13  26  39  52  65  78  91 104 117 130 143   1   2   3   4
#  0  14  28  42  56  70  84  98 112 126 140 154   2   3   4   5
#  0  15  30  45  60  75  90 105 120 135 150 165   3   4   5   6

# Window:
#  0   1   2   3
#  1   2   3   4
#  2   3   4   5
#  3   4   5   6

# cord x = 12, cord y = 12 returned in $v0 and $v1 registers

.text
.globl  vbsme

# Your program must follow circular search pattern.

# Preconditions:
#   1st parameter (a0) address of the first element of the dimension info (address of asize[0])
#   2nd parameter (a1) address of the first element of the frame array (address of frame[0][0])
#   3rd parameter (a2) address of the first element of the window array (address of window[0][0])
# Postconditions:
#   result (v0) x coordinate of the block in the frame with the minimum SAD
#          (v1) y coordinate of the block in the frame with the minimum SAD


# Begin subroutine
vbsme:
    # Initialize return values
    addi    $v0, $zero, 0
    addi    $v1, $zero, 0

    add     $s8, $zero, $ra

    # Read window and frame dimensions from memory
    lw      $t0, 0($a0)
    lw      $t1, 4($a0)
    lw      $t2, 8($a0)
    lw      $t3, 12($a0)

    # Calculate frame - window width and column offsets
    sub     $s7, $t0, $t2
    sub     $s5, $t1, $t3

    # Initialize minimum row
    addi    $s4, $zero, 0

    # Initialize minimum column
    addi    $s6, $zero, 0

    # Initialize current row and column position
    addi    $t4, $zero, 0
    addi    $t5, $zero, 0

    # Initialize best row and column position
    addi    $s0, $zero, 0
    addi    $s1, $zero, 0

    # Initialize sum with highest value
    addi    $s3, $zero, -1      # 0xFFFFFFFF
    srl     $s3, $s3, 1         # 0x7FFFFFFF

search_loop:

right_loop:
    # Send to calculate sad starting from the current position and go through the window
    jal     calculate_sad

    # Check if current SAD is better than best SAD
    slt     $t8, $s2, $s3

    # If not better, skip the update
    beq     $t8, $zero, right_no_update

    # Save new best SAD
    add     $s3, $zero, $s2

    # Save row of best position
    add     $s0, $zero, $t4

    # Save column of best position
    add     $s1, $zero, $t5

right_no_update:
    # If at max column, stop moving right
    beq     $t5, $s5, right_done

    # Move one column to the right
    addi    $t5, $t5, 1

    # Check the new position
    j       right_loop


right_done:
    # Move minimum row boundary down, since we dont want to go through it again
    addi    $s6, $s6, 1

    # If min row passed max row, search is finished
    #For example if the frame is 4x4 and the window is 4x4, then after moving right, we will move down,
    #but since the min row is now 1 and max row is 0, we will stop searching
    slt     $t8, $s7, $s6
    bne     $t8, $zero, search_done


down_loop:
    # Move one row down
    addi    $t4, $t4, 1

    # Send to calculate sad starting from the current position and go through the window
    jal     calculate_sad

    # Check if current SAD is better
    slt     $t8, $s2, $s3

    # If not better, skip the update
    beq     $t8, $zero, down_no_update

    # Save new best SAD
    add    $s3, $zero, $s2

    # Save row of best position
    add    $s0, $zero, $t4

    # Save column of best position
    add    $s1, $zero, $t5

down_no_update:
    # If at max row, stop moving down
    beq     $t4, $s7, down_done

    # Continue moving down
    j       down_loop


down_done:
    # Move maximum column boundary inward
    addi    $s5, $s5, -1

    # If max column passed min column, search is finished
    slt     $t8, $s5, $s4
    bne     $t8, $zero, search_done


left_loop:
    # Move one column to the left
    addi    $t5, $t5, -1

    # Send to calculate sad starting from the current position and go through the window
    jal     calculate_sad

    # Check if current SAD is better
    slt     $t8, $s2, $s3

    # If not better, skip the update
    beq     $t8, $zero, left_no_update

    # Save new best SAD
    add    $s3, $zero, $s2

    # Save row of best position
    add    $s0, $zero, $t4

    # Save column of best position
    add    $s1, $zero, $t5

left_no_update:
    # If at min column, stop moving left
    beq     $t5, $s4, left_done

    # Continue moving left
    j       left_loop


left_done:
    # Move maximum row boundary inward
    addi    $s7, $s7, -1

    # If max row passed min row, search is finished
    slt     $t8, $s7, $s6
    bne     $t8, $zero, search_done


up_loop:
    # Move one row up
    addi    $t4, $t4, -1

    # Send to calculate sad starting from the current position and go through the window
    jal     calculate_sad

    # Check if current SAD is better
    slt     $t8, $s2, $s3

    # If not better, skip the update
    beq     $t8, $zero, up_no_update

    # Save new best SAD
    add    $s3, $zero, $s2

    # Save row of best position
    add    $s0, $zero, $t4

    # Save column of best position
    add    $s1, $zero, $t5

up_no_update:
    # If at min row, stop moving up
    beq     $t4, $s6, up_done

    # Continue moving up
    j       up_loop


up_done:
    # Move minimum column boundary inward
    addi    $s4, $s4, 1

    # If min column passed max column, search is finished
    slt     $t8, $s5, $s4
    bne     $t8, $zero, search_done

    # Start next inner ring at the new minimum column
    add    $t5, $zero, $s4

    # Start another circular search
    j       search_loop


search_done:
    # Return best row
    add    $v0, $zero, $s0

    # Return best column
    add    $v1, $zero, $s1

    # Restore original return address
    add    $ra, $zero, $s8

    # Return to the caller
    jr      $ra
calculate_sad:
    addi    $s2, $zero, 0
    addi    $t6, $zero, 0

sad_row_loop:
    slt     $t8, $t6, $t2
    beq     $t8, $zero, sad_done

    addi    $t7, $zero, 0

sad_col_loop:
    # If row is done branch to next row
    slt     $t8, $t7, $t3
    beq     $t8, $zero, sad_next_row

    # Calculate frame row
    # Current row frame position + current window row
    add     $t8, $t4, $t6
    # Multiply frame row by frame width
    mul     $t8, $t8, $t1
    # Add the current column position
    add     $t8, $t8, $t5
    # Add the current window column offset
    add     $t8, $t8, $t7
    # Convert to byte offset and load
    sll     $t8, $t8, 2
    add     $t8, $a1, $t8
    lw      $t8, 0($t8)

    # Current  window row * window width
    mul     $t9, $t6, $t3
    # Add current window column
    add     $t9, $t9, $t7
    # Convert to byte offset load
    sll     $t9, $t9, 2
    add     $t9, $a2, $t9
    lw      $t9, 0($t9)

    # Calculate difference
    sub     $t8, $t8, $t9
    # If difference is positive skip to difference positive
    # otherwise subtract from zero to make positive
    bgez    $t8, difference_positive
    sub     $t8, $zero, $t8

difference_positive:
    # Add the current absolute difference to the running total
    add     $s2, $s2, $t8
    # Increment window column
    addi    $t7, $t7, 1
    j       sad_col_loop

sad_next_row:
    # Increment window row
    addi    $t6, $t6, 1
    j       sad_row_loop

sad_done:
    jr      $ra
