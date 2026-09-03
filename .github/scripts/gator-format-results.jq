# `gator test -o json` has changed its top-level shape across versions (some
# wrap each entry in a "result" key, some don't; some nest the constraint
# under "constraint.object", some put it at "constraint" directly). Normalize
# both shapes here so this keeps working across gator upgrades.
def entry: (.result // .);
def constraint_obj: (entry.constraint.object // entry.constraint // {});
def enforcement_action: (entry.enforcementAction // entry.enforcementaction // "unknown");

def icon:
  if . == "deny" then "❌"
  elif . == "warn" then "⚠️"
  elif . == "dryrun" then "🔍"
  else "❔"
  end;

def escape_cell:
  gsub("\\|"; "\\|") | gsub("\r?\n"; " ");

def resource_label:
  ((.kind // "?") + "/" + (.metadata.namespace // "-") + "/" + (.metadata.name // "?"));

def constraint_label:
  ((.kind // "?") + "/" + (.metadata.name // "?"));

if length == 0 then
  "✅ **No Gatekeeper policy violations found.**"
else
  ([.[] | select(enforcement_action == "deny")] | length) as $deny
  | (
      if $deny > 0 then
        "🚫 **\($deny) blocking violation(s)** found (enforcementAction: deny)."
      else
        "⚠️ No blocking violations, but \(length) advisory result(s) were reported."
      end
    ) as $summary
  | $summary
  + "\n\n"
  + "| | Enforcement | Constraint | Resource | Message |\n"
  + "|---|---|---|---|---|\n"
  + (
      map(
        (enforcement_action) as $ea
        | "| " + ($ea | icon) + " | " + $ea
          + " | " + (constraint_obj | constraint_label)
          + " | " + (.violatingObject | resource_label)
          + " | " + (entry.msg // "" | escape_cell)
          + " |"
      ) | join("\n")
    )
end
