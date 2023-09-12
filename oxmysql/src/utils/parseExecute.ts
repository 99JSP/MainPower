import { CFXParameters } from '../types';

export const executeType = (query: string) => {
  if (typeof query !== 'string') throw new Error(`Expected query to be a string but received ${typeof query} instead.`);

  switch (query.substring(0, query.indexOf(' '))) {
    case 'INSERT':
      return 'insert';
    case 'UPDATE':
      return 'update';
    case 'DELETE':
      return 'update';
    default:
      return null;
  }
};

export const parseExecute = (placeholders: number, parameters: CFXParameters) => {
  const parametersType = typeof parameters;

  if (!parameters || parametersType !== 'object') return [];

  if (!Array.isArray(parameters)) {
    if (typeof parameters === 'object') {
      const arr: unknown[] = [];
      Object.entries(parameters).forEach((entry) => (arr[parseInt(entry[0]) - 1] = entry[1]));
      parameters = arr;
    } else throw new Error(`Parameters expected an array but received ${typeof parameters} instead`);
  }

  if (!parameters.every(Array.isArray)) {
    if (parameters.every((item) => typeof item === 'object')) {
      const arr: unknown[][] = [];

      parameters.forEach((value, index) => {
        arr[index] = new Array(placeholders);

        if (!Array.isArray(value)) {
          Object.entries(value).forEach((entry) => {
            arr[index][parseInt(entry[0]) - 1] = entry[1];
          });
        } else arr[index] = parameters[index];

        for (let i = 0; i < placeholders; i++) {
          if (arr[index][i] === undefined) arr[index][i] = null;
        }
      });

      parameters = arr;
    } else parameters = [[...parameters]];
  }

  return parameters;
};

export const parseValues = (placeholders: number, parameters: CFXParameters) => {
  if (!Array.isArray(parameters)) {
    if (typeof parameters === 'object') {
      const arr: unknown[] = [];
      Object.entries(parameters).forEach((entry) => (arr[parseInt(entry[0]) - 1] = entry[1]));
      parameters = arr;
    } else throw new Error(`Parameters expected an array but received ${typeof parameters} instead`);
  } else if (placeholders > parameters.length) {
    for (let i = parameters.length; i < placeholders; i++) {
      parameters[i] = null;
    }
  }

  return parameters;
};
