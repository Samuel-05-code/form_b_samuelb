// Librería de Flutter.
import 'package:flutter/material.dart';

// Librería Flutter Form Builder (formularios).
import 'package:flutter_form_builder/flutter_form_builder.dart';

// Inicio de la app.
void main() {
  runApp(const MyApp());
}

// Clase principal de la app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Título de la app.
      title: 'M0489 - Apps - Form (B)',

      // Colores de la app.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),

      // Pantalla que se abre al iniciar.
      home: const MyHomePage(),
    );
  }
}

// Pantalla principal.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Título de la barra de arriba.
  final String title = 'Samuel Brudeanu';

  // Clave del formulario.
  final _formKey = GlobalKey<FormBuilderState>();

  // Paso actual (0, 1 o 2).
  int _currentStep = 0;

  // Los 3 pasos.
  List<Step> _steps(BuildContext context) {
    return [

      // Paso 1
      Step(
        title: const Text('Pers.'),
        state: StepState.indexed,
        isActive: _currentStep >= 0,
        content: const StepInfo(
          title: 'Personal',
          text: 'Pulsi "Contact" o pulsi el botó de "Continue".',
        ),
      ),

      // Paso 2
      Step(
        title: const Text('Contact'),
        state: StepState.editing,
        isActive: _currentStep >= 1,
        content: const StepInfo(
          title: 'Contact',
          text: 'Pulsi "Upload" o pulsi el botó de "Continue".',
        ),
      ),

      // Paso 3: formulario
      Step(
        title: const Text('Upload'),
        state: StepState.complete,
        isActive: _currentStep >= 2,
        content: FormBuilder(
          key: _formKey,
          child: Column(
            children: [

              // Campo Email
              FormBuilderTextField(
                name: 'Email',
                decoration: fieldDecoration(
                  context,
                  'Email',
                  Icons.email,
                ),
                onChanged: (String? value) {
                  debugPrint(value);
                },
              ),

              const SizedBox(height: 12),

              // Campo Address
              FormBuilderTextField(
                name: 'Address',
                maxLines: 4,
                decoration: fieldDecoration(
                  context,
                  'Address',
                  Icons.home,
                ),
                onChanged: (String? value) {
                  debugPrint(value);
                },
              ),

              const SizedBox(height: 12),

              // Campo Mobile
              FormBuilderTextField(
                name: 'Mobile',
                decoration: fieldDecoration(
                  context,
                  'Mobile No',
                  Icons.phone,
                ),
                onChanged: (String? value) {
                  debugPrint(value);
                },
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Step> steps = _steps(context);

    return Scaffold(

      // Barra de arriba.
      appBar: AppBar(
        backgroundColor:
        Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),

      // Para que los pasos quepan si la letra del móvil es grande.
      body: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.0,

        // Stepper con los 3 pasos.
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,

          // Al pulsar un paso, vamos a ese paso.
          onStepTapped: (int step) {
            setState(() => _currentStep = step);
          },

          // Botón CONTINUE.
          onStepContinue: () {
            if (_currentStep < steps.length - 1) {
              // Siguiente paso.
              setState(() => _currentStep += 1);
            } else {
              // Último paso: guardamos el formulario.
              _formKey.currentState?.saveAndValidate();

              // Cogemos los datos del formulario.
              String? formString =
              _formKey.currentState?.value.toString();

              // Mostramos los datos.
              alertDialog(context, formString!);
            }
          },

          // Botón CANCEL: paso anterior.
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },

          steps: steps,
        ),
      ),
    );
  }
}

// Estilo de los campos del formulario.
InputDecoration fieldDecoration(
    BuildContext context,
    String hint,
    IconData icon) {

  // Azul clarito.
  final Color lightColor =
      Theme.of(context).colorScheme.inversePrimary;

  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: lightColor),
    prefixIcon: Icon(icon, color: lightColor),

    // Borde normal.
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: lightColor),
    ),

    // Borde al seleccionar el campo.
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    ),
  );
}

// Contenido de los pasos 1 y 2: título y texto.
class StepInfo extends StatelessWidget {
  const StepInfo({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Título.
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),

        // Texto.
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

// Ventana con los datos del formulario.
void alertDialog(
    BuildContext context,
    String contentText) {

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      icon: const Icon(
        Icons.check_circle,
      ),
      title: const Text(
        'Submission Completed',
      ),
      content: Text(contentText),
      actions: <Widget>[
        // Botón para cerrar.
        TextButton(
          onPressed: () =>
              Navigator.pop(context, 'Close'),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}