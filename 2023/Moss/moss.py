import mosspy
userid = 61861013

m = mosspy.Moss(userid, "python")
m.addFilesByWildcard("/home/cial1/Moss/Submissions/*")

url = m.send()
print (url)
