import 'package:flutter/material.dart';

void main() {
  runApp(const HelpDesk());
}

class HelpDesk extends StatelessWidget {
  const HelpDesk({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HelpDesk',
      theme: ThemeData(useMaterial3: true),
      home: const ListaTickets(),
    );
  }
}

class Ticket {
  final int id;
  final String titulo;
  final String cliente;
  final String prioridad;

  Ticket({
    required this.id,
    required this.titulo,
    required this.cliente,
    required this.prioridad,
  });
}

// Pantalla 1: Lista
class ListaTickets extends StatefulWidget {
  const ListaTickets({super.key});

  @override
  State<ListaTickets> createState() => _ListaTicketsState();
}

class _ListaTicketsState extends State<ListaTickets> {
  final List<Ticket> tickets = [
    Ticket(id: 1, titulo: 'VPN no funciona', cliente: 'Juan', prioridad: 'Alta'),
    Ticket(id: 2, titulo: 'Error en app', cliente: 'María', prioridad: 'Alta'),
    Ticket(id: 3, titulo: 'Resetear contraseña', cliente: 'Carlos', prioridad: 'Media'),
    Ticket(id: 4, titulo: 'Instalar software', cliente: 'Ana', prioridad: 'Media'),
    Ticket(id: 5, titulo: 'Monitor no enciende', cliente: 'Pedro', prioridad: 'Alta'),
    Ticket(id: 6, titulo: 'Printer no imprime', cliente: 'Laura', prioridad: 'Baja'),
    Ticket(id: 7, titulo: 'Email bloqueado', cliente: 'Roberto', prioridad: 'Media'),
    Ticket(id: 8, titulo: 'Teclado roto', cliente: 'Sofia', prioridad: 'Baja'),
  ];

  Color _getColor(String prioridad) {
    if (prioridad == 'Alta') return Colors.red;
    if (prioridad == 'Media') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HelpDesk'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Ajustes()));
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getColor(ticket.prioridad),
                child: Text(
                  '${ticket.id}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(ticket.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${ticket.cliente} • ${ticket.prioridad}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetalleTicket(ticket: ticket)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Pantalla 2: Detalle con FutureBuilder
class DetalleTicket extends StatefulWidget {
  final Ticket ticket;

  const DetalleTicket({super.key, required this.ticket});

  @override
  State<DetalleTicket> createState() => _DetalleTicketState();
}

class _DetalleTicketState extends State<DetalleTicket> {
  late int contador;

  @override
  void initState() {
    super.initState();
    contador = 30;
  }

  Future<String> _cargar() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Cargado';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: FutureBuilder<String>(
        future: _cargar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Cargando...')],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('#${widget.ticket.id} - ${widget.ticket.titulo}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Cliente: ${widget.ticket.cliente}'),
                          const SizedBox(height: 8),
                          Chip(label: Text(widget.ticket.prioridad)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onDoubleTap: () {
                      setState(() => contador = 30);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contador reseteado')),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text('Tiempo Estimado (doble tap = reset)',
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: Text('$contador min',
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue)),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() => contador -= 10);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Tiempo: $contador min')),
                                    );
                                  },
                                  icon: const Icon(Icons.remove),
                                  label: const Text('- 10'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() => contador += 10);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Tiempo: $contador min')),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('+ 10'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Volver'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Pantalla 3: Ajustes
class Ajustes extends StatelessWidget {
  const Ajustes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Acerca de', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('HelpDesk v1.0'),
                    SizedBox(height: 4),
                    Text('Sistema de tickets de soporte'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}