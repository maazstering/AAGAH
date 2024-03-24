dataString = '''
Defence ke raaste flooded.
Log phase hue Bahadurabad char minar pe.
Malir mai koi masla nahi Malir best.
'''

keyWords = ['Bahadurabad', 'Malir', 'Gulshan', 'Defence', 'Gulberg', 'Liaquatabad', 'Nazimabad', 'New Karachi', 'North Nazimabad', 'Faisal Cantonment', 'Ferozabad', 'Gulshan-e-Iqbal', 'Gulzar-e-Hijri', 'Jamshed Quarters', 'Aram Bagh', 'Civil Line', 'Clifton Cantonment', 'Garden', 'Karachi Cantonment', 'Saddar', 'Lyari', 'Baldia', 'Harbour', 'Mango Pir', 'Manora Cantonment', 'Mauripur', 'Mominabad', 'Orangi', 'Sindh Industrial Trading Estate', 'Korangi', 'Landhi', 'Model Colony', 'Shah Faisal', 'Airport', 'Bin Qasim', 'Gadap', 'Ibrahim Hyderi', 'Korangi Creek Cantonment', 'Malir Cantonment', 'Murad Memon', 'Shah Mureed', 'Keamari']


for keyWord in keyWords:
    index = 0
    indexes = []
    indexFound = 0

    while indexFound != -1:
        indexFound = dataString.find(keyWord, index)
        

        if indexFound not in indexes:
            indexes.append(indexFound)

        index += 1

    indexes.pop(-1)
    if indexes!=[] : print (keyWord, " = ", dataString)
    