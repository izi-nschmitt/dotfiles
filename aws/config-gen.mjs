import fs from "node:fs/promises";

const __dirname = import.meta.dirname;
const { HOME } = process.env;

const kebabCase = (input) =>
  input
    .replace(/([a-z])([A-Z])/g, "$1-$2")
    .replace(/[\s_]+/g, "-")
    .toLowerCase();

const getAccounts = async () => {
  const account = await fs.readFile(__dirname + "/accounts.json", "utf-8");
  const patches = await fs.readFile(__dirname + "/patches.json", "utf-8");
  const accounts = JSON.parse(account);
  const patchList = JSON.parse(patches);

  return accounts.map((account) => ({
    ...account,
    ...(patchList[account.id] || {}),
  }));
};

const getSsoSession = () => `
[sso-session cassiopeia]
sso_start_url = https://iziwork.awsapps.com/start
sso_region = eu-west-1
sso_registration_scopes = sso:account:access
`;

const getDefaultProfile = () => `
[default]
sso_session = cassiopeia
region = eu-west-1
cli_auto_prompt = on-partial
`;

const getProfile = ({ name, id }) => `
[profile ${kebabCase(name)}]
sso_session = cassiopeia
sso_account_id = ${id}
sso_role_name = AWSAdministratorAccess
region = eu-west-1
cli_auto_prompt = on-partial
cli_pager =
`;

const generateConfig = async () => {
  const accounts = await getAccounts();

  await fs.copyFile(
    HOME + "/.aws/config",
    HOME + "/.aws/config.bak",
    fs.constants.COPYFILE_FICLONE
  );

  await fs.writeFile(
    HOME + "/.aws/config",
    [getSsoSession(), getDefaultProfile(), ...accounts.map(getProfile)]
      .join("")
      .trimStart(),
    "utf-8"
  );
};

await generateConfig();
