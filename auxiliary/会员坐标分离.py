import csv

myfile = open("handle.csv", "r")
new_file = open("new.csv", "wb")
csv_writer = csv.writer(new_file)
csv_reader = csv.reader(myfile)
for i in csv_reader:
    for dual in i:
        dual = dual.split(" ")
        csv_writer.writerow(dual)
myfile.close()
new_file.close()


