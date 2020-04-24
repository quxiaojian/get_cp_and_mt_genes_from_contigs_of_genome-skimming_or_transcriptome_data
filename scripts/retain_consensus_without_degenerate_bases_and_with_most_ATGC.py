import sys,os,shutil

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print('python 4_test.py DIR OUTPUT')
        sys.exit(0)

    DIR = sys.argv[1]
    if DIR[-1] != "/": DIR = DIR + "/"
    OUTPUT = sys.argv[2]

    current_path = os.getcwd()
    newfolder_path = os.path.join(current_path, OUTPUT)
    if not os.path.exists(newfolder_path):
        os.mkdir(newfolder_path)
    else:
        shutil.rmtree(newfolder_path)

    def containJianbing(line):
        jianbing = ['Y', 'R', 'K', 'M', 'W', 'S', 'D', 'H', 'V', 'B']
        for i in jianbing:
            if i in line:
                return True
        return False


    folderpath1_list = []
    folderpath2_list = []
    dict_foldername1 = {}
    filenames = []
    genenames = []
    foldername1 = os.listdir(DIR)#hit80
    for folder1 in foldername1:
        folderpath1 = os.path.join(DIR, folder1)#cycads/hit80
        folderpath1_list.append(folderpath1)
        foldername2 = os.listdir(folderpath1)#Bser
        for i in foldername2:
            dict_foldername1[i] = 0
        for folder2 in foldername2:
            folderpath2 = os.path.join(folderpath1, folder2)#cycads/hit80/Bser
            folderpath2_list.append(folderpath2)
            filename = os.listdir(folderpath2)#accD_consensus.fasta
            for file in filename:
                if file.endswith('_consensus.fasta'):
                    filenames.append(file)
                    filepath = os.path.join(folderpath2, file)#cycads/hit80/Bser/accD_consensus.fasta
                    genename = file.replace('_consensus.fasta', '')#accD
                    genenames.append(genename)

    for taxon_name in dict_foldername1:
        target_path1 = current_path + os.path.sep + OUTPUT + os.path.sep + taxon_name
        if not os.path.exists(target_path1):
            os.makedirs(target_path1)#cycads_consensus/Bser
        else:
            pass

    for folder1 in foldername1:#hit80
        folderpath1 = os.path.join(DIR, folder1)#cycads/hit80
        foldername2 = os.listdir(folderpath1)#Bser
        for folder2 in foldername2:#Bser
            folderpath2 = os.path.join(folderpath1, folder2)#cycads/hit80/Bser
            filename = os.listdir(folderpath2)#accD_consensus.fasta accD_divergent.fasta
            for file in filename:
                if file.endswith('_consensus.fasta'):#accD_consensus.fasta
                    filepath = os.path.join(folderpath2, file)#cycads/hit80/Bser/accD_consensus.fasta
                    genename = file.replace('_consensus.fasta', '')#accD
                    with open(filepath, 'r+') as f_in:
                        content_1 = f_in.readlines()
                        seq = ''.join([i.strip() for i in content_1[1:]])
                        #number_N = seq.upper().count('N')
                        if containJianbing(seq) is True:
                            pass
                        else:
                            outfile_path = current_path + os.path.sep + OUTPUT + os.path.sep + folder2 + os.path.sep + genename + '_consensus.fasta'
                            with open(outfile_path, 'a+') as f_out:
                                file_size = os.path.getsize(outfile_path)
                                if file_size != 0:
                                    f_out.write(seq + '\n')
                                elif file_size == 0:
                                    f_out.write('>' + genename + '_' + folder2 + '\n')
                                    f_out.write(seq + '\n')

    for root, dirs, files in os.walk(newfolder_path):#cycads_consensus
        for file_name in files:#accD_consensus.fata
            con_filepath = os.path.join(root, file_name)#cycads_consensus/Bser/accD_consensus.fasta
            gene_name = file_name.replace('_consensus.fasta', '')#accD
            dict_number = {}
            with open(con_filepath, 'r+') as file_in:
                content = file_in.readlines()
                for line in content:
                    if line.startswith('>'):
                        pass
                    else:
                        line = line.upper()
                        ATGC = line.count('A') + line.count('T') + line.count('G') + line.count('C')
                        #line = line.replace('N', '-')
                        dict_number[line] = ATGC
                if dict_number:
                    seq_number = max(dict_number, key = dict_number.get)
                out_path = os.path.dirname(con_filepath) + os.path.sep + gene_name + '.fasta'
                with open(out_path, 'w') as file_out:
                    file_out.write(content[0])
                    file_out.write(seq_number)
            os.remove(con_filepath)
