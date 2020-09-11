#

# luis.rodriguezcaro@umconnect.umt.edu
Since you are interested on the circle plots I am sending you the input files and the script that I used to generate it in R (attached)
You should be able to recreate it using your own alignment files. While this script uses a specific output of a MUMmer alignment,
it should work for any other alignment output as long as it is in tabular format. All the columns that you need are the coordinates
of start (S) and end (E) points from your reference (R) and query (Q) scaffolds. In my script you will see that these columns are
named  RS, RE, QS and QE respectively. You may also need to make sure your alignment table includes the length of R and Q scaffolds
(named L1 and L2 in my script). s long as you name these columns the same way in your data the script may not require further changes.

Please excuse any confusion generated by my scripting style. I wrote it during my Master's and I'm not an experienced programmer,
so you might find that is not the best script to follow. Please let me know if you have any question, I'll be happy to help.

# file is in software/circle_plot_genome_alignment.zip on local

# R scripts.


# Since you are interested on the circle plots I am sending you the input files and the script
# that I used to generate it in R (attached)  You should be able to recreate it using your own
# alignment files. While this script uses a specific output of a MUMmer alignment, it should
# work for any other alignment output as long as it is in tabular format. All the columns
# that you need are the coordinates of start (S) and end (E) points from your reference (R)
# and query (Q) scaffolds. In my script you will see that these columns are named  RS, RE, QS
# and QE respectively. You may also need to make sure your alignment table includes the length
# of R and Q scaffolds (named L1 and L2 in my script). As long as you name these columns the
# same way in your data the script may not require further changes.


# ID_color_palette_1
ch	color
chr_01	'red'
chr_02	'#00FF89'
chr_03	'#FF3B00'
chr_04	'#00FFC4'
chr_05	'#FF7600'
chr_06	'cyan'
chr_07	'#FFB100'
chr_08	'#00C4FF'
chr_09	'#FFEB00'
chr_10	'#0089FF'
chr_11	'#D8FF00'
chr_12	'#004EFF'
chr_13	'#9DFF00'
chr_14	'#0014FF'
chr_15	'#62FF00'
chr_16	'#2700FF'
chr_17	'#27FF00'
chr_18	'#6200FF'
chr_19	'#00FF14'
chr_20	'#9D00FF'
chr_21	'#00FF4E'

# ID_color_palette_2
ch	color
chr_01	'red4'
chr_02	'grey'
chr_03	'red4'
chr_04	'grey'
chr_05	'red4'
chr_06	'grey'
chr_07	'red4'
chr_08	'grey'
chr_09	'red4'
chr_10	'grey'
chr_11	'red4'
chr_12	'grey'
chr_13	'red4'
chr_14	'grey'
chr_15	'red4'
chr_16	'grey'
chr_17	'red4'
chr_18	'grey'
chr_19	'red4'
chr_20	'grey'
chr_21	'red4'