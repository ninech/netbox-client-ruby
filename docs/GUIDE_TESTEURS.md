# Guide testeurs — migration NetBox 4.6.1

> Mise à jour requise par les guidelines projet : toute fonctionnalité majeure
> documente ici son impact sur le parcours de test.

## Périmètre de la branche `feat/netbox-4.6.1-bulk-object-changes`

Alignement de la gem sur NetBox **4.6.1** (le fork ciblait déjà la sérialisation
v4 : `status`/`action` sont des objets `{value, label}`, les FK sont des objets
imbriqués en lecture et acceptent un entier en écriture). Deux ajouts majeurs :

- **Exigence A — Opérations de masse** (`NetboxClientRuby::BulkOperations`,
  disponible sur toutes les collections).
- **Exigence B — Lecture incrémentale des changements** (`core.object_changes`)
  + `get_list` filtrable/paginé généralisé à toutes les entités.

## Ce qu'un testeur doit vérifier

### Bulk (calqué sur les lots IDAS ports/câbles)
1. `dcim.cables.bulk_create([...])` renvoie les objets **complets** : vérifier
   que chaque élément retourné porte un `id` exploitable (`result.map(&:id)`).
2. `bulk_update([...])` : chaque élément **doit** contenir un `id`, sinon
   `NetboxClientRuby::LocalError` est levé avant tout appel réseau.
3. `bulk_delete([id, {id:}, entity])` : accepte ids, hashes ou entités, envoie
   un corps `[{id: …}]`, renvoie le nombre d'éléments supprimés.
4. **Erreur 400 par élément** : sur rejet partiel, une `NetboxClientRuby::BulkError`
   est levée ; vérifier `error.failures` → liste `{index:, errors:, item:}` ne
   contenant **que** les éléments rejetés (l'item renvoyé est le payload soumis,
   pour reconstituer la ligne IDAS fautive). `error.total_failure?` distingue un
   rejet partiel d'un rejet global.

### Pagination / polling incrémental
1. `core.object_changes.get_list({ changed_object_type_id: [12, 34],
   time_after: ts, ordering: '-time' }, limit: 100)` : confirmer l'encodage en
   `changed_object_type_id=12&changed_object_type_id=34&…` (clés répétées).
2. `#results` / `#next_url` / `#previous_url` exposent la page courante et les
   curseurs bruts renvoyés par NetBox.
3. `#all_pages` suit `next` jusqu'à épuisement et agrège tous les enregistrements
   (à utiliser pour un cycle de polling complet). Vérifier sur un jeu > 1 page.

## Lancer les tests

```
bundle install
bundle exec rspec spec/netbox_client_ruby/bulk_operations_spec.rb \
                  spec/netbox_client_ruby/api/core/object_changes_spec.rb
```

> Note : la logique bulk + agrégation multi-pages est aussi couverte par un
> harness autonome (`harness.rb`) qui n'exige aucune dépendance externe, utile
> en environnement sans accès rubygems.

## Limites connues / à confirmer côté instance 4.6.1
- En-tête de version d'API : non imposé par le schéma fourni ; à valider au runtime.
- Champs réellement requis sur Cable (le schéma déclare `required: []`).
- Liste exacte des `object_type` acceptés pour les terminaisons de câble.
