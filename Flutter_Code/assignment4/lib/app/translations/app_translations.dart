import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // App General
      'app_title': 'Todo App',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'settings': 'Settings',
      'search': 'Search',
      'filter': 'Filter',
      'clear': 'Clear',

      // Todo specific
      'todos': 'Todos',
      'add_todo': 'Add Todo',
      'edit_todo': 'Edit Todo',
      'todo_title': 'Title',
      'todo_description': 'Description',
      'todo_priority': 'Priority',
      'todo_completed': 'Completed',
      'todo_pending': 'Pending',
      'todo_created': 'Created',
      'todo_updated': 'Updated',

      // Priority levels
      'priority_low': 'Low',
      'priority_medium': 'Medium',
      'priority_high': 'High',

      // Messages
      'todo_added': 'Todo added successfully',
      'todo_save_success': 'Todo updated successfully',
      'todo_deleted': 'Todo deleted successfully',
      'todo_marked_completed': 'Todo marked as completed',
      'todo_uncompleted': 'Todo marked as pending',
      'no_todos': 'No todos found',
      'enter_title': 'Please enter a title',

      // Statistics
      'total_todos': 'Total Todos',
      'completed_todos': 'Completed',
      'pending_todos': 'Pending',
      'high_priority_todos': 'High Priority',

      // Filters
      'show_completed': 'Show Completed',
      'hide_completed': 'Hide Completed',
      'all_priorities': 'All Priorities',
      'clear_filters': 'Clear Filters',

      // Settings
      'theme': 'Theme',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'app_settings': 'App Settings',

      // Confirmation
      'delete_todo_title': 'Delete Todo',
      'delete_todo_message': 'Are you sure you want to delete this todo?',
      'confirm': 'Confirm',
    },

    'es_ES': {
      // App General
      'app_title': 'Aplicación de Tareas',
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      'add': 'Agregar',
      'settings': 'Configuración',
      'search': 'Buscar',
      'filter': 'Filtrar',
      'clear': 'Limpiar',

      // Todo specific
      'todos': 'Tareas',
      'add_todo': 'Agregar Tarea',
      'edit_todo': 'Editar Tarea',
      'todo_title': 'Título',
      'todo_description': 'Descripción',
      'todo_priority': 'Prioridad',
      'todo_completed': 'Completado',
      'todo_pending': 'Pendiente',
      'todo_created': 'Creado',
      'todo_updated': 'Actualizado',

      // Priority levels
      'priority_low': 'Baja',
      'priority_medium': 'Media',
      'priority_high': 'Alta',

      // Messages
      'todo_added': 'Tarea agregada exitosamente',
      'todo_save_success': 'Tarea actualizada exitosamente',
      'todo_deleted': 'Tarea eliminada exitosamente',
      'todo_marked_completed': 'Tarea marcada como completada',
      'todo_uncompleted': 'Tarea marcada como pendiente',
      'no_todos': 'No se encontraron tareas',
      'enter_title': 'Por favor ingrese un título',

      // Statistics
      'total_todos': 'Total de Tareas',
      'completed_todos': 'Completadas',
      'pending_todos': 'Pendientes',
      'high_priority_todos': 'Prioridad Alta',

      // Filters
      'show_completed': 'Mostrar Completadas',
      'hide_completed': 'Ocultar Completadas',
      'all_priorities': 'Todas las Prioridades',
      'clear_filters': 'Limpiar Filtros',

      // Settings
      'theme': 'Tema',
      'language': 'Idioma',
      'dark_mode': 'Modo Oscuro',
      'light_mode': 'Modo Claro',
      'app_settings': 'Configuración de la App',

      // Confirmation
      'delete_todo_title': 'Eliminar Tarea',
      'delete_todo_message': '¿Está seguro de que desea eliminar esta tarea?',
      'confirm': 'Confirmar',
    },

    'fr_FR': {
      // App General
      'app_title': 'Application de Tâches',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'add': 'Ajouter',
      'settings': 'Paramètres',
      'search': 'Rechercher',
      'filter': 'Filtrer',
      'clear': 'Effacer',

      // Todo specific
      'todos': 'Tâches',
      'add_todo': 'Ajouter une Tâche',
      'edit_todo': 'Modifier la Tâche',
      'todo_title': 'Titre',
      'todo_description': 'Description',
      'todo_priority': 'Priorité',
      'todo_completed': 'Terminé',
      'todo_pending': 'En attente',
      'todo_created': 'Créé',
      'todo_updated': 'Mis à jour',

      // Priority levels
      'priority_low': 'Faible',
      'priority_medium': 'Moyenne',
      'priority_high': 'Élevée',

      // Messages
      'todo_added': 'Tâche ajoutée avec succès',
      'todo_save_success': 'Tâche mise à jour avec succès',
      'todo_deleted': 'Tâche supprimée avec succès',
      'todo_marked_completed': 'Tâche marquée comme terminée',
      'todo_uncompleted': 'Tâche marquée comme en attente',
      'no_todos': 'Aucune tâche trouvée',
      'enter_title': 'Veuillez entrer un titre',

      // Statistics
      'total_todos': 'Total des Tâches',
      'completed_todos': 'Terminées',
      'pending_todos': 'En attente',
      'high_priority_todos': 'Priorité Élevée',

      // Filters
      'show_completed': 'Afficher Terminées',
      'hide_completed': 'Masquer Terminées',
      'all_priorities': 'Toutes les Priorités',
      'clear_filters': 'Effacer les Filtres',

      // Settings
      'theme': 'Thème',
      'language': 'Langue',
      'dark_mode': 'Mode Sombre',
      'light_mode': 'Mode Clair',
      'app_settings': 'Paramètres de l\'App',

      // Confirmation
      'delete_todo_title': 'Supprimer la Tâche',
      'delete_todo_message': 'Êtes-vous sûr de vouloir supprimer cette tâche?',
      'confirm': 'Confirmer',
    },

    'ar_SA': {
      // App General
      'app_title': 'تطبيق المهام',
      'loading': 'جارٍ التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تحرير',
      'add': 'إضافة',
      'settings': 'الإعدادات',
      'search': 'بحث',
      'filter': 'تصفية',
      'clear': 'مسح',

      // Todo specific
      'todos': 'المهام',
      'add_todo': 'إضافة مهمة',
      'edit_todo': 'تحرير المهمة',
      'todo_title': 'العنوان',
      'todo_description': 'الوصف',
      'todo_priority': 'الأولوية',
      'todo_completed': 'مكتمل',
      'todo_pending': 'قيد الانتظار',
      'todo_created': 'تم الإنشاء',
      'todo_updated': 'تم التحديث',

      // Priority levels
      'priority_low': 'منخفض',
      'priority_medium': 'متوسط',
      'priority_high': 'عالي',

      // Messages
      'todo_added': 'تم إضافة المهمة بنجاح',
      'todo_save_success': 'تم تحديث المهمة بنجاح',
      'todo_deleted': 'تم حذف المهمة بنجاح',
      'todo_marked_completed': 'تم تعيين المهمة كمكتملة',
      'todo_uncompleted': 'تم تعيين المهمة كقيد الانتظار',
      'no_todos': 'لم يتم العثور على مهام',
      'enter_title': 'يرجى إدخال العنوان',

      // Statistics
      'total_todos': 'إجمالي المهام',
      'completed_todos': 'مكتملة',
      'pending_todos': 'قيد الانتظار',
      'high_priority_todos': 'أولوية عالية',

      // Filters
      'show_completed': 'إظهار المكتملة',
      'hide_completed': 'إخفاء المكتملة',
      'all_priorities': 'جميع الأولويات',
      'clear_filters': 'مسح المرشحات',

      // Settings
      'theme': 'السمة',
      'language': 'اللغة',
      'dark_mode': 'الوضع المظلم',
      'light_mode': 'الوضع الفاتح',
      'app_settings': 'إعدادات التطبيق',

      // Confirmation
      'delete_todo_title': 'حذف المهمة',
      'delete_todo_message': 'هل أنت متأكد من رغبتك في حذف هذه المهمة؟',
      'confirm': 'تأكيد',
    },
  };
}
