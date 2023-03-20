import 'dart:convert';

import 'package:flutter/material.dart';

import 'class.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'News App',
      home: NewsList(),
    );
  }
}

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = getNewsData();
  }

  Future<List<Article>> getNewsData() async {
    const String url =
        "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=4f63681140c84fe6a9d781bedb2e4472";

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<Article> articles = [];
        Map<String, dynamic> jsonData = json.decode(response.body);


        for (var item in jsonData["articles"] as List) {
        articles.add(Article(author: item['author']??'', title: item['title']??'', description: item['description']??'', url: item['url']??'', urlToImage: item['urlToImage']??'', publishedAt: item['publishedAt']??'', content: item['content']??''));
        }

        return articles;
      } else {
        throw Exception("Failed to load news data");
      }
    } catch (e) {
      throw Exception("Failed to load news data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
      ),
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Article>? articles = snapshot.data;
            return ListView.builder(
              itemCount: articles!.length,
              itemBuilder: (context, index) {
                Article article = articles[index];
                return ListTile(
                  title: Text(article.title.toString()),
                  subtitle: Text(article.description.toString()),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load news data'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
