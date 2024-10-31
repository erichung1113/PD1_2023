import mosspy, sys
userid = 61861013

for i in range(1, len(sys.argv)):
    problem = sys.argv[i]
    print("Uploading " + problem + " ......")
    
    m = mosspy.Moss(userid, "python")
    m.addFilesByWildcard(f"Submissions/${problem}/*")

    url = m.send()
    print (url
