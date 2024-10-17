/**
 * Author: liwb
 * Date: 2024/10/17
 * Description: 优雅的处理 Promise await 异常，仿照 await-to-js(https://www.npmjs.com/package/await-to-js)
 */

/**
 * @param { Promise } promise
 * @param { Object= } errorExt - Additional Information you can pass to the err object
 * @return { Promise }
 */
export function to<T, U extends Error>(
  promise: Promise<T>,
  errorExt?: object
): Promise<[U, undefined] | [null, T]> {
  return promise
    .then<[null, T]>((data: T) => [null, data])
    .catch<[U, undefined]>((err: U) => {
      if (errorExt) {
        const parsedError = new Object() as U;

        for (let key of Reflect.ownKeys(err) as string[]) {
          Reflect.set(parsedError, key, Reflect.get(err, key))
        }

        for (let key of Reflect.ownKeys(errorExt) as string[]) {
          Reflect.set(parsedError, key, Reflect.get(errorExt, key))
        }

        return [parsedError, undefined]
      }
      return [err, undefined]
    });
}

export default to;

// 调用示例
// interface IPerson {
//   name: string;
//   age: number;
//   remark: string;
// }
// const getLongLived = (): Promise<IPerson> => {
//   return new Promise((resolve, reject) => {
//     const age = Math.ceil(Math.random() * 200);
//     const person = { name: 'zhang3', age, remark: '法外狂徒' } as IPerson;
//
//     if (age < 100) {
//       return reject(new Error('He is not a long-lived person!'));
//     }
//
//     resolve(person);
//   })
// }
//
// const result = await to(getLongLived());
// const err = result[0];
// const person = result[1];
//
// if (err) {
//   // 处理异常
//   promptAction.showToast({
//     message: err.message,
//   });
//
//   return;
// }
// console.log('正常执行);
//

