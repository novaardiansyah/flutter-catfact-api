import 'package:cat_facts_app/services/cat_fact_service.dart';
import 'package:flutter/material.dart';
import 'package:cat_facts_app/models/fact.dart';

class CatFacts extends StatefulWidget {
  const CatFacts({super.key});

  @override
  State<CatFacts> createState() => _CatFactsState();
}

class _CatFactsState extends State<CatFacts> {
  final CatFactService _catFactService = CatFactService.instance;
  String? _fact = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addFactButton(),
      body: _factList(),
      appBar: AppBar(
        title: const Text('Nova Ardiansyah'),
      ),
    );
  }

  Widget _factList() {
    return FutureBuilder(
      future: _catFactService.getFacts(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Fact fact = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: ListTile(
                  onLongPress: () {
                    _catFactService.deleteFact(fact.id);
                    setState(() {});
                  },
                  title: Text(fact.description),
                  trailing: Text(fact.fromApi == 1 ? 'API' : '')
                  // Checkbox(value: fact.fromApi == 1, onChanged: (value) {}),
                  ),
            );
          },
        );
      },
    );
  }

  Widget _addFactButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text(
                    'Tambah Fakta Baru',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () async {
                            String data = await _catFactService.fetchCatFact();
                            _catFactService.addFact(data, 1);
                            
                            setState(() {
                                _fact = data;
                            });

                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Generate dari API')),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _fact = value;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Fakta lain yang Anda ketahui...'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (_fact == null || _fact == '') return;
                        _catFactService.addFact(_fact!, 0);
                        setState(() {
                          _fact = null;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ));
      },
    );
  }
}
