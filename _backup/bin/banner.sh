printf """
                            __                
                           |  \               
  ______   ______  _______ | ▓▓   __ __    __ 
 /      \ |      \|       \| ▓▓  /  \  \  |  \\
|  ▓▓▓▓▓▓\ \▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\ ▓▓_/  ▓▓ ▓▓  | ▓▓
| ▓▓  | ▓▓/      ▓▓ ▓▓  | ▓▓ ▓▓   ▓▓| ▓▓  | ▓▓
| ▓▓__/ ▓▓  ▓▓▓▓▓▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓\| ▓▓__/ ▓▓
| ▓▓    ▓▓\▓▓    ▓▓ ▓▓  | ▓▓ ▓▓  \▓▓\\\\\▓▓    ▓▓
| ▓▓▓▓▓▓▓  \▓▓▓▓▓▓▓\▓▓   \▓▓\▓▓   \▓▓ \▓▓▓▓▓▓ 
| ▓▓                                          
| ▓▓    %s                                      
 \▓▓    %s                                      

""" \
    "$(uname -sr)" \
    "$(date)"

