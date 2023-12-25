import subprocess
import sys

with open(sys.argv[1]) as f:
    lines = f.readlines()

with open("input.dot", "w") as f:
    f.write("graph {\n")
    for line in lines:
        u, vs = line.strip().split(": ")
        f.write(f"    {u} -- {{ {vs} }}\n")
    f.write("}\n")

subprocess.getoutput("cluster -C2 input.dot > clustered.dot")
subprocess.getoutput("dot -Ksfdp -Tpdf clustered.dot > clustered.pdf")

subprocess.getoutput("open clustered.pdf")
print("See which edges cross clusters. Enter vertex pairs: ", end="")

# Format: "bvb cmg jqt nvd hfx pzl" becomes [('bvb', 'cmg'), ('jqt', 'nvd'), ('hfx', 'pzl')]
vs = input().split()
pairs = [(vs[2*i], vs[2*i+1]) for i in range(len(vs) // 2)]

to_remove = set()
for (u, v) in pairs:
    to_remove.add(f"{u} -- {v}")
    to_remove.add(f"{v} -- {u}")

with open("clustered.dot", "r") as clustered:
    with open("cleaned.dot", "w") as cleaned:
        for line in clustered:
            for edge in to_remove:
                if edge in line:
                    print("Cutting edge:", line.strip())
                    break
            else:
                cleaned.write(line)

subprocess.getoutput("cluster -C2 cleaned.dot > cleaned_clustered.dot")
subprocess.getoutput(
    "dot -Ksfdp -Tpdf cleaned_clustered.dot > cleaned_clustered.pdf")

# subprocess.getoutput("open cleaned_clustered.pdf")

count1 = int(subprocess.getoutput('grep -c "cluster=1" cleaned_clustered.dot'))
count2 = int(subprocess.getoutput('grep -c "cluster=2" cleaned_clustered.dot'))
# for some reason there is a third cluster despite the -C2 flag??
count3 = int(subprocess.getoutput('grep -c "cluster=3" cleaned_clustered.dot'))

print(f"Answer: {count1} * {count2+count3} = {(count1) * (count2+count3)}")
