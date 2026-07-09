# Changelog

## 0.17.0 — Alignement NetBox 4.6.1 + bulk & object-changes

### Ajouts (rétrocompatibles)
- `NetboxClientRuby::BulkOperations` mixé dans toutes les collections :
  `#bulk_create`, `#bulk_update`, `#bulk_delete` (corps en tableau, retour des
  objets complets avec `id`).
- `NetboxClientRuby::BulkError` : erreur typée portant `#failures`
  (`{index:, errors:, item:}` par élément rejeté), `#errors`, `#total_failure?`.
- `NetboxClientRuby.core.object_changes` (`/api/core/object-changes/`),
  lecture seule, pour le polling incrémental.
- `Entities#get_list(filters, limit:, offset:)`, `#results`, `#next_url`,
  `#previous_url`, `#all_pages`, `#each_page` — généralisés à toutes les entités.

### Aucune rupture d'API publique
Les méthodes existantes (`#all`, `#filter`, `#limit`, `#offset`, `#total`,
énumération) sont inchangées. Les nouvelles méthodes sont purement additives.
