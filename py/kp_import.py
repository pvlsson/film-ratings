# parse the HTML file
with open('ratings_1_200.html', 'r') as f:
    soup = BeautifulSoup(f, 'html.parser')

# find all the film items
film_items = soup.find_all('div', class_='item')

# create lists to store the data
nameEng = []
nameRus = []
rating = []
date = []

# loop through each film item and extract the data
for film in film_items:
    # extract the film name (in English)
    name_eng = film.find('div', class_='nameEng')
    nameEng.append(name_eng)

    # extract the film name (in Russian)
    name_rus = film.find('div', class_='nameRus')
    nameRus.append(name_rus)

    # extract the rating
    rating_script = film.find('script', string=lambda s: 'ur_data.push' in str(s))
    if rating_script is not None:
        rating_string = rating_script.text
        rating_value = int(re.search(r"rating: '(\d+)'", rating_string).group(1))
        rating.append(rating_value)
    else:
        rating.append(None)

    # extract the date
    date_string = film.find('div', class_='date')
    date.append(date_string)

# create a DataFrame from the lists
df = pd.DataFrame({
    'nameEng': nameEng,
    'nameRus': nameRus,
    'rating': rating,
    'date': date
})

# display the DataFrame
print(df)

# write the DataFrame to a CSV file
df.to_csv('export_ratings_1_200.csv', index=False)